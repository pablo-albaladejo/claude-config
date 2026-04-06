---
name: setup-agents-md
description: Generate AGENTS.md, Claude Code subagents (.claude/agents/), and skills (.claude/skills/) for a project. Use when setting up a repository for AI agent collaboration.
disable-model-invocation: true
argument-hint: "[optional: specific focus areas or agent descriptions]"
---

# Setup AGENTS.md + Agents + Skills

Generate an `AGENTS.md` file, Claude Code subagents, and skills for this
project. Update `CLAUDE.md` to reference `@AGENTS.md`.

## Step 1: Explore the project

Before writing anything, thoroughly analyze the codebase:

- `package.json` (or equivalent): scripts, dependencies, engines
- Config files: `tsconfig.json`, ESLint, Prettier, Vitest/Jest, Webpack/Vite, etc.
- CI/CD: `.github/workflows/`, `.gitlab-ci.yml`, `Jenkinsfile`, etc.
- IaC: SAM templates, CDK, Terraform, serverless.yml, etc.
- Existing `CLAUDE.md`, `README.md`, `CONTRIBUTING.md`
- `src/` structure to understand architecture and patterns
- `.env.example` for environment setup
- Existing tests to identify testing conventions
- `.nvmrc`, `.tool-versions`, `Dockerfile` for runtime requirements
- Existing `.claude/` directory: agents, skills, commands, settings
- MCP servers configured in `.claude.json` or settings

## Step 2: Design agents and skills

Based on the project and the user's request ($ARGUMENTS), decide what to create:

### Claude Code Subagents (`.claude/agents/<name>.md`)

Subagents are specialized AI assistants that run in their own context window.
They are invoked via the Task tool and return results to the caller.

**When to create an agent:**
- A specialized role with a focused system prompt (reviewer, investigator, etc.)
- Tasks that should run in isolation to preserve main context
- Work that can be parallelized (multiple agents running simultaneously)
- Roles needing restricted tool access or a specific model

**Agent file format** (`.claude/agents/<name>.md`):
```yaml
---
name: agent-name           # Required: lowercase + hyphens
description: When to use   # Required: Claude uses this to decide delegation
tools: Tool1, Tool2        # Optional: restrict tools (inherits all if omitted)
disallowedTools: Write     # Optional: deny specific tools
model: sonnet              # Optional: sonnet|opus|haiku|inherit (default: inherit)
permissionMode: default    # Optional: default|acceptEdits|dontAsk|bypassPermissions|plan
maxTurns: 20               # Optional: limit agentic turns
skills:                    # Optional: preload skill content at startup
  - skill-name
memory: user               # Optional: user|project|local — persistent memory across sessions
---

System prompt in markdown. This is the ONLY prompt the agent receives
(not the full Claude Code system prompt). Be specific and detailed.
```

**Key rules for agents:**
- Agents CANNOT spawn other agents (no nesting)
- Agents are invoked via the Task tool from the main conversation or a skill
- Use `model: sonnet` or `model: haiku` for cost-effective specialized tasks
- Store at `.claude/agents/` (project-level) or `~/.claude/agents/` (user-level)

### Claude Code Skills (`.claude/skills/<name>/SKILL.md`)

Skills are reusable instructions that run in the main conversation context
(or forked into a subagent with `context: fork`).

**When to create a skill:**
- Reusable workflows triggered by `/skill-name`
- Multi-step procedures that orchestrate agents
- Reference content (conventions, patterns) Claude should apply
- Tasks with side effects the user should trigger manually

**Skill file format** (`.claude/skills/<name>/SKILL.md`):
```yaml
---
name: skill-name                  # Optional: defaults to directory name
description: What it does         # Recommended: helps Claude decide when to use it
disable-model-invocation: true    # Optional: only user can invoke (for side-effect workflows)
user-invocable: false             # Optional: only Claude can invoke (for background knowledge)
allowed-tools: Read, Bash         # Optional: tools allowed without permission prompts
model: opus                       # Optional: model override
context: fork                     # Optional: run in isolated subagent context
agent: Explore                    # Optional: which agent type for context: fork
---

Instructions in markdown. Supports $ARGUMENTS for user input.
```

**Key rules for skills:**
- Skills CAN orchestrate agents via the Task tool
- Skills run in the main conversation context by default
- Use `context: fork` + `agent: <type>` to run in a subagent
- Store at `.claude/skills/<name>/SKILL.md` (with optional supporting files)
- Skills can have supporting files in their directory (templates, scripts, etc.)

### DO NOT use `.claude/commands/`

Commands (`.claude/commands/<name>.md`) are legacy and have been merged into
skills. Always use `.claude/skills/<name>/SKILL.md` instead.

## Step 3: Create AGENTS.md

Create `AGENTS.md` at the project root. Keep it **under 150 lines** and
vendor-neutral. Include these sections as applicable:

| Section | Content |
|---------|---------|
| **Project Overview** | One sentence establishing context |
| **Architecture** | Structure diagram showing agents/skills flow if applicable |
| **Package Manager** | npm/yarn/pnpm/bun + Node/runtime version |
| **Dev Environment** | Setup commands in a table |
| **Build & Test Commands** | All relevant scripts in a table |
| **Code Style & Conventions** | Derived from actual config |
| **Agent definitions** | Summary of each agent: role, model, tools, inputs/outputs |
| **Skill definitions** | Summary of each skill: purpose, invocation |
| **Shared Context** | Data/conventions shared across agents |
| **Infrastructure** | IaC templates, deployment info |
| **Testing** | Conventions, mocking patterns |
| **CI/CD** | Pipeline stages, commit conventions |
| **Dos and Don'ts** | Concrete rules derived from the codebase |

### Writing guidelines

- Be **specific and concrete** — no vague advice
- Derive all rules from the **actual codebase**, not assumptions
- Use **tables** for commands and agent/skill summaries
- Focus on what agents need to **contribute correctly**
- Do NOT invent conventions that don't exist in the project
- Skip sections that don't apply

## Step 4: Create agent and skill files

Create the actual `.claude/agents/*.md` and `.claude/skills/*/SKILL.md` files
designed in Step 2. For each file:

1. Write a clear, focused system prompt / instruction set
2. Restrict tools to only what the agent/skill needs
3. Choose the right model (sonnet for fast tasks, opus for complex reasoning)
4. Define clear input/output contracts so agents can be chained

## Step 5: Update CLAUDE.md

- If `CLAUDE.md` exists: add `@AGENTS.md` reference at the top, remove content
  now covered by `AGENTS.md`, keep only Claude-specific instructions
- If `CLAUDE.md` does not exist: create it with `@AGENTS.md` reference and
  minimal project-specific guidelines

$ARGUMENTS
