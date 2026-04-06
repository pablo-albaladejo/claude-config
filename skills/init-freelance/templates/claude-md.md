# CLAUDE.md Template

Generate the following content for the project root `CLAUDE.md`, replacing `{{PROJECT_NAME}}` and `{{PROJECT_BRIEF}}`:

```markdown
# {{PROJECT_NAME}}

## Project Overview

{{PROJECT_BRIEF}}

## Current Phase

**Discovery & Ideation** — Defining the product, clarifying requirements, and building mockups.

## Rules

- **Documentation language**: ALL content in `docs/`, `mockups/`, and `CLAUDE.md` MUST be written in English, regardless of conversation language.
- **Conversation language**: Conversations can be in any language the user prefers. Always respond in the language the user uses.
- **Decision tracking**: Every significant decision must be logged in `docs/decisions.md` with date, context, decision, and reasoning.
- **Questions tracking**: Any question or ambiguity requiring client input must go in `docs/questions.md`.
- **Product definition**: `docs/product.md` is the living source of truth for what we're building. Keep it updated after every iteration.
- **No code yet**: This phase is about understanding and defining. Do not write application code unless explicitly asked.
- **Be critical**: Do not be complacent. Challenge assumptions, suggest simpler alternatives, and ask hard questions.

## Project Structure

```
docs/
  brief.md        — Original client brief/requirements
  product.md      — Product definition (living document, source of truth)
  decisions.md    — Decision log with reasoning
  questions.md    — Open questions for the client
mockups/           — Wireframes, ASCII diagrams, user flows
```

## Available Skills

| Skill | Usage | Purpose |
|---|---|---|
| `/iterate` | `/iterate "onboarding flow"` | Refine a specific aspect of the product |
| `/challenge` | `/challenge "we need social auth"` | Devil's advocate — question assumptions |
| `/simplify` | `/simplify "payment system"` | Find the simplest MVP version |
| `/perspective` | `/perspective "UX designer"` | Analyze from a specific role |
| `/questions` | `/questions "registration flow"` | Generate questions for the client |
| `/decision` | `/decision "use Stripe for payments"` | Document a decision with context and alternatives |
| `/status` | `/status` | Executive summary of current project state |
| `/mockup` | `/mockup "login screen"` | Generate ASCII wireframe or flow diagram |

## Available Agents

- **ux-analyst** — Evaluates user flows, usability, and experience. Has project memory.
- **tech-advisor** — Evaluates technical feasibility, architecture, and complexity. Has project memory.
- **business-analyst** — Evaluates business viability, market fit, and priorities. Has project memory.

## Workflow

1. Each session starts by reading this file to resume context
2. Iterate on `docs/product.md` refining the product definition
3. Important decisions go to `docs/decisions.md`
4. Client questions go to `docs/questions.md`
5. Use `/skills` for structured analysis workflows
6. Use agents for deep specialized analysis
```
