---
name: code-review
description: Review code changes for architecture, patterns, and quality. Challenges assumptions from multiple perspectives before reporting findings.
user-invocable: true
allowed-tools: Read, Glob, Grep, Task, Bash
---

# Code Review

Review code changes critically, challenging from multiple perspectives before reporting.

## Input

- `<target>`: A branch name, commit range, file list, or "staged" for staged changes

## Process

1. **Collect the diff** — Read the changed files and understand what each change does
2. **Read surrounding context** — Read the unchanged code around each change to understand the full picture
3. **Apply the review checklist** — Check each point below, reporting only actual findings
4. **Challenge from multiple roles** — For each finding, consider whether an SRE, architect, or product engineer would agree

## Review Checklist

### Validation ownership
When validation or data transformation is added, check: **does the producer already guarantee this?**
- If the code controls the entire pipeline (e.g., LLM call → queue → consumer → DB), validation belongs at the origin — not scattered across every layer
- Redundant checks in downstream layers create dispersed responsibility, inconsistencies (different layers enforcing different rules), and harder debugging
- Truncating data silently is almost always worse than rejecting at the source and retrying — truncation produces broken UX, retries produce meaningful content
- Ask: "who owns this data?" If we do, validate once at creation. If external, validate at the boundary.

### Architecture compliance
- Layer dependencies respected (domain ← application ← adapters, no inward-to-outward imports)
- Types/interfaces in the right layer (ports in application, implementations in adapters)
- No business logic in adapters, no infrastructure in domain

### Consistency
- New code follows the same patterns as existing code in the same codebase
- If a pattern is used in one place but not another similar place, flag it
- Naming conventions match surrounding code

### Error handling
- Errors are handled at the right level (not swallowed, not leaked across boundaries)
- Async errors can't silently disappear
- Error messages are useful for debugging (include IDs, context)

### Testing
- Tests cover the actual behavior change, not just happy path
- Mocks match the real interfaces they replace
- No testing implementation details — test behavior and outcomes

### Simplicity
- Could this change be smaller while solving the same problem?
- Are there abstractions that don't earn their complexity?
- Is there dead code, unused imports, or unnecessary changes?

## Output Format

For each finding:
```
**[severity]** file:line — description

Why: explanation of the impact
Suggestion: what to do instead (if applicable)
```

Severities: `blocker` (must fix), `warning` (should fix), `nit` (optional improvement), `question` (needs clarification)

End with a summary: total findings by severity, overall assessment (approve / request changes).
