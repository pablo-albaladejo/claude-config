---
name: init-freelance
description: Initialize a freelance project with full Claude Code structure including skills, sub-agents, hooks, documentation templates, and CLAUDE.md
disable-model-invocation: true
argument-hint: [project-brief-description]
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, AskUserQuestion
---

# Init Freelance Project

Initialize a complete freelance project structure optimized for iterative product discovery with Claude Code.

## Input

`$ARGUMENTS` contains the project brief or description.

If `$ARGUMENTS` is empty or too vague, use AskUserQuestion to gather:
- What is the project about?
- Who is the client?
- What problem does it solve?
- What is the expected deliverable?

## Steps

### 1. Check prerequisites

Verify the current directory is a git repo and is mostly empty (no existing `.claude/skills/` or `docs/`). If not, warn the user and ask for confirmation before proceeding.

### 2. Create directory structure

```bash
mkdir -p docs mockups \
  .claude/skills/{iterate,challenge,simplify,perspective,questions,decision,status,mockup/examples} \
  .claude/agents \
  .claude/hooks
```

### 3. Generate CLAUDE.md

Use the template from [templates/claude-md.md](templates/claude-md.md). Replace:
- `{{PROJECT_NAME}}` with the git repository directory name
- `{{PROJECT_BRIEF}}` with the project description from `$ARGUMENTS`

### 4. Generate documentation files

Use the templates from [templates/docs.md](templates/docs.md) to create:
- `docs/brief.md` — Seed with whatever info came from `$ARGUMENTS`
- `docs/product.md` — Empty living document template
- `docs/decisions.md` — Empty decision log
- `docs/questions.md` — Seed with initial questions based on the brief

### 5. Generate project skills

Use the templates from [templates/skills.md](templates/skills.md) to create all 8 skill directories under `.claude/skills/`.

**IMPORTANT**: Adapt each skill's description and instructions to reference the specific project domain from `$ARGUMENTS`. Do NOT use generic placeholders — make them specific.

### 6. Generate project agents

Use the templates from [templates/agents.md](templates/agents.md) to create 3 agent files under `.claude/agents/`.

**IMPORTANT**: Same as skills — adapt to the project domain.

### 7. Configure hooks

Use the template from [templates/hooks.json](templates/hooks.json) and write it to `.claude/settings.json`. If the file already exists, merge the hooks configuration without overwriting existing settings.

### 8. Create a .gitkeep in mockups/

```bash
touch mockups/.gitkeep
```

### 9. Summary

After creating everything, output a clear summary:
- List all files created
- Explain the available `/skills` and what each does
- Explain the available agents
- Suggest a first action (e.g., "Start by running `/status` or paste your client brief into `docs/brief.md`")
