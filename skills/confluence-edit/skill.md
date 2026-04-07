# Confluence Page Editor

Edit Confluence Cloud pages while preserving inline comments and annotations.

## The Problem

The Atlassian MCP tool (`mcp__atlassian__updateConfluencePage`) accepts `markdown` or `adf` content format. When you pass markdown, Confluence converts it to fresh HTML — destroying all `<ac:inline-comment-marker>` tags. Inline comments appear as "deleted" in the UI.

## The Solution: ADF Round-Trip via REST API

Inline comments are stored in ADF as `annotation` marks on text nodes:

```json
{
  "type": "text",
  "text": "annotated text",
  "marks": [
    {
      "type": "annotation",
      "attrs": {
        "id": "UUID-matching-the-comment",
        "annotationType": "inlineComment"
      }
    }
  ]
}
```

To preserve them, you must:

1. **Read** the page in ADF format (contains annotation marks)
2. **Modify** the ADF JSON surgically (never regenerate from scratch)
3. **Write** the modified ADF back via the REST API v2

## Step-by-Step Workflow

### Step 1: Check for inline comments

Before editing, always check if the page has inline comments:

```
mcp__atlassian__getConfluencePageInlineComments(cloudId, pageId)
```

If there are **no** inline comments → safe to use the MCP tool with markdown format (simpler).

If there **are** inline comments → use the ADF round-trip method below.

### Step 2: Get the page ADF

```
mcp__atlassian__getConfluencePage(cloudId, pageId, contentFormat="adf")
```

The result is large (saved to a file). Search for `"annotationType"` to confirm annotations are present.

### Step 3: Download via REST API

The ADF from the MCP tool may be too large to pass back as a tool parameter. Use the REST API directly:

```bash
AUTH=$(echo -n "email:api-token" | base64)

# Download current ADF
curl -s -H "Authorization: Basic $AUTH" \
  "https://{site}.atlassian.net/wiki/api/v2/pages/{pageId}?body-format=atlas_doc_format" \
  > /tmp/page.json

# Extract ADF body and version
python3 -c "
import json, re
with open('/tmp/page.json','r') as f:
    raw = f.read()
clean = re.sub(r'[\x00-\x1f\x7f-\x9f]', '', raw)
data = json.loads(clean)
adf = json.loads(data['body']['atlas_doc_format']['value'])
print('Version:', data['version']['number'])
print('Annotations:', json.dumps(adf).count('annotationType'))
with open('/tmp/adf.json','w') as f:
    json.dump(adf, f)
"
```

### Step 4: Modify the ADF with Python

Use surgical modifications that preserve the tree structure and all marks:

```python
import json, copy

with open("/tmp/adf.json", "r") as f:
    adf = json.load(f)

content = adf["content"]
annotations_before = json.dumps(adf).count('"annotationType"')

# === TEXT REPLACEMENTS (preserves marks automatically) ===
def walk_and_replace(node, replacements):
    if isinstance(node, dict):
        if node.get("type") == "text" and "text" in node:
            for old, new in replacements:
                if old in node["text"]:
                    node["text"] = node["text"].replace(old, new)
        if "content" in node and isinstance(node["content"], list):
            for child in node["content"]:
                walk_and_replace(child, replacements)

walk_and_replace(adf, [("old text", "new text")])

# === INSERT NEW NODES ===
# Find a heading by text, insert after it
for i, node in enumerate(content):
    if node.get("type") == "heading":
        for c in node.get("content", []):
            if "target heading" in c.get("text", ""):
                new_paragraph = {
                    "type": "paragraph",
                    "content": [{"type": "text", "text": "New content here"}]
                }
                content.insert(i + 1, new_paragraph)
                break

# === VERIFY ANNOTATIONS ===
annotations_after = json.dumps(adf).count('"annotationType"')
assert annotations_before == annotations_after, "Annotations lost!"

with open("/tmp/modified_adf.json", "w") as f:
    json.dump(adf, f)
```

### Step 5: Upload via REST API

```bash
AUTH=$(echo -n "email:api-token" | base64)

# Build request body
python3 -c "
import json
with open('/tmp/modified_adf.json','r') as f:
    adf = json.load(f)
request = {
    'id': '{pageId}',
    'status': 'current',
    'title': 'Page Title',
    'body': {
        'representation': 'atlas_doc_format',
        'value': json.dumps(adf)
    },
    'version': {
        'number': CURRENT_VERSION + 1,
        'message': 'Description of changes'
    }
}
with open('/tmp/request.json','w') as f:
    json.dump(request, f)
"

# Upload
curl -s -w "%{http_code}" \
  -X PUT \
  -H "Authorization: Basic $AUTH" \
  -H "Content-Type: application/json" \
  -d @/tmp/request.json \
  "https://{site}.atlassian.net/wiki/api/v2/pages/{pageId}"
```

## ADF Cookbook

### Common ADF node types

```python
# Paragraph with bold + code
{"type": "paragraph", "content": [
    {"type": "text", "text": "Bold text", "marks": [{"type": "strong"}]},
    {"type": "text", "text": "code", "marks": [{"type": "code"}]},
    {"type": "text", "text": " normal text"}
]}

# Heading
{"type": "heading", "attrs": {"level": 3}, "content": [
    {"type": "text", "text": "Section Title"}
]}

# Bullet list
{"type": "bulletList", "content": [
    {"type": "listItem", "content": [
        {"type": "paragraph", "content": [{"type": "text", "text": "Item 1"}]}
    ]}
]}

# Table
{"type": "table", "attrs": {"isNumberColumnEnabled": False, "layout": "default"}, "content": [
    {"type": "tableRow", "content": [
        {"type": "tableHeader", "content": [{"type": "paragraph", "content": [{"type": "text", "text": "Header"}]}]},
    ]},
    {"type": "tableRow", "content": [
        {"type": "tableCell", "content": [{"type": "paragraph", "content": [{"type": "text", "text": "Cell"}]}]},
    ]}
]}

# Code block
{"type": "codeBlock", "attrs": {"language": "json"}, "content": [
    {"type": "text", "text": "{ \"key\": \"value\" }"}
]}
```

### Map headings to indices (useful for finding insertion points)

```python
for i, node in enumerate(content):
    if node.get("type") == "heading":
        texts = [c["text"] for c in node.get("content", []) if c.get("type") == "text"]
        print(f"[{i}] H{node['attrs']['level']}: {''.join(texts)}")
```

## Rules

1. **ALWAYS check for inline comments first** before editing a page
2. **NEVER use the MCP tool with markdown format** if there are inline comments
3. **ALWAYS count annotations before and after** modifications and assert they match
4. **NEVER regenerate content from scratch** — always modify the existing ADF tree
5. **Text replacements are safe** — they preserve marks (including annotation marks) on the text node
6. **Insertions are safe** — adding new nodes doesn't affect existing annotation marks
7. **Deletions are dangerous** — removing a node that contains an annotation mark will orphan the comment
8. The user needs to provide an **Atlassian API token** for direct REST API access (MCP tool can't handle large ADF bodies)

## Auth

API tokens are created at: https://id.atlassian.com/manage-profile/security/api-tokens

Used as Basic Auth: `Authorization: Basic base64(email:token)`

Remind the user to delete the token after use.
