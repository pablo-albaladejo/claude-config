# Skill Templates

Generate each skill as `.claude/skills/<name>/SKILL.md`. Adapt descriptions and instructions to the specific project domain.

---

## iterate

```yaml
---
name: iterate
description: Refine and improve a specific aspect of the product definition. Use when discussing features, flows, or requirements.
argument-hint: [aspect-to-refine]
allowed-tools: Read, Write, Edit, Grep, Glob
---

Refine the following aspect of the product: $ARGUMENTS

1. Read `docs/product.md` for current product state
2. Read `docs/decisions.md` for existing decisions that may constrain this area
3. Analyze the specific aspect requested
4. Propose concrete improvements with reasoning
5. Ask the user which direction they prefer
6. Update `docs/product.md` with the agreed changes
7. If any decisions were made, append them to `docs/decisions.md`

Be specific. Avoid vague suggestions. Every proposal must be actionable.
```

---

## challenge

```yaml
---
name: challenge
description: Play devil's advocate — question assumptions and find weaknesses in product decisions
disable-model-invocation: true
argument-hint: [assumption-or-decision-to-challenge]
allowed-tools: Read, Grep, Glob
---

Challenge this assumption or decision: $ARGUMENTS

1. Read `docs/product.md` and `docs/decisions.md` for full context
2. Identify unstated assumptions behind this decision
3. Present 3-5 strong counterarguments
4. For each counterargument, explain:
   - What could go wrong
   - Who would be affected
   - What evidence would validate or invalidate the assumption
5. Suggest specific questions to ask the client (add to `docs/questions.md` if the user agrees)
6. Rate the risk: low / medium / high

Do NOT be diplomatic. Be direct, critical, and specific.
```

---

## simplify

```yaml
---
name: simplify
description: Find the simplest possible version of a feature or system — ruthless MVP thinking
disable-model-invocation: true
argument-hint: [feature-or-system-to-simplify]
allowed-tools: Read, Grep, Glob
---

Simplify this to its absolute minimum: $ARGUMENTS

1. Read `docs/product.md` for context
2. Identify the core value — what is the ONE thing this must do?
3. Propose 3 levels:
   - **Bare minimum**: The simplest thing that could possibly work
   - **Lean MVP**: Minimum viable but not embarrassing
   - **Current scope**: What's currently defined
4. For each level, specify:
   - What's included / excluded
   - Estimated relative complexity (1x, 2x, 5x)
   - What you lose vs gain
5. Recommend which level to start with and why

Bias toward less. The best feature is the one you don't build.
```

---

## perspective

```yaml
---
name: perspective
description: Analyze the product from a specific professional role or persona
context: fork
agent: general-purpose
argument-hint: [role-name]
allowed-tools: Read, Grep, Glob
---

You are acting as a **$ARGUMENTS[0]**.

Read `docs/product.md` and analyze the entire product from this role's perspective.

Structure your analysis as:

1. **First impression**: What stands out immediately?
2. **Strengths**: What's well thought out from this perspective?
3. **Concerns**: What worries you? Be specific.
4. **Blind spots**: What has the team likely not considered?
5. **Recommendations**: Top 3 concrete suggestions, prioritized.

Common roles and their focus:
- **UX designer**: User flows, friction points, accessibility, mental models
- **Backend engineer**: Data model, APIs, scalability, security, complexity
- **Frontend engineer**: UI state, responsiveness, component architecture
- **QA engineer**: Edge cases, error states, testability
- **Product manager**: Prioritization, scope, user stories, metrics
- **End user**: Ease of use, value proposition, learning curve
- **Investor**: Market size, differentiation, monetization, growth

Be opinionated. Do not hedge. Provide a clear, actionable perspective.
```

---

## questions

```yaml
---
name: questions
description: Generate specific questions for the client about an area of the product
disable-model-invocation: true
argument-hint: [product-area]
allowed-tools: Read, Write, Edit, Grep, Glob
---

Generate questions about: $ARGUMENTS

1. Read `docs/product.md` for product context
2. Read `docs/questions.md` to avoid duplicates
3. Generate 5-10 specific, answerable questions about this area
4. Categorize each question:
   - **Blocking**: Cannot proceed without this answer
   - **Important**: Significantly affects the design
   - **Clarifying**: Would improve our understanding
5. For each question, briefly explain WHY we need this answer
6. Propose the questions to the user
7. If approved, append them to `docs/questions.md` under Pending

Write questions the CLIENT can answer. Avoid technical jargon. Be concrete — "What happens when X?" is better than "How should we handle edge cases?"
```

---

## decision

```yaml
---
name: decision
description: Document a product or technical decision with full context, alternatives, and reasoning
disable-model-invocation: true
argument-hint: [decision-statement]
allowed-tools: Read, Write, Edit, Grep, Glob
---

Document this decision: $ARGUMENTS

1. Read `docs/decisions.md` for the current decision count (to assign the next #)
2. Read `docs/product.md` for context
3. Structure the decision:
   - **Decision**: Clear, one-line statement of what was decided
   - **Context**: Why did this decision come up? What triggered it?
   - **Alternatives considered**: At least 2 alternatives with pros/cons
   - **Reasoning**: Why this option over the others?
4. Present the structured decision to the user for confirmation
5. If confirmed, append to `docs/decisions.md`
6. Update `docs/product.md` if the decision affects the product definition
7. Remove any related questions from `docs/questions.md` Pending section
```

---

## status

```yaml
---
name: status
description: Generate an executive summary of the current project state
argument-hint: []
allowed-tools: Read, Grep, Glob
---

Generate a project status report.

1. Read `CLAUDE.md` for project overview
2. Read `docs/product.md` — assess completeness of each section
3. Read `docs/decisions.md` — count and summarize recent decisions
4. Read `docs/questions.md` — count pending vs answered questions
5. Scan `mockups/` for existing artifacts

Report format:

## Project Status: {{project name}}

**Phase**: Current phase from CLAUDE.md
**Last updated**: Today's date

### Product Definition
- Completeness: X% (estimate based on filled sections)
- Areas well defined: [list]
- Areas needing work: [list]

### Decisions
- Total: N decisions made
- Recent: [last 3 decisions summarized]

### Open Questions
- Pending: N questions awaiting answers
- Blocking: N questions blocking progress

### Mockups
- Total: N artifacts
- Coverage: [which flows/screens are covered]

### Recommended Next Steps
1. [Most impactful action]
2. [Second priority]
3. [Third priority]
```

---

## mockup

```yaml
---
name: mockup
description: Generate ASCII wireframes, user flow diagrams, or screen layouts
disable-model-invocation: true
argument-hint: [screen-or-flow-name]
allowed-tools: Read, Write, Grep, Glob
---

Create a mockup for: $ARGUMENTS

1. Read `docs/product.md` for product context and features
2. Read existing files in `mockups/` to maintain consistency
3. Determine the type of mockup needed:
   - **Screen layout**: ASCII wireframe of a UI screen
   - **User flow**: Step-by-step flow diagram
   - **State diagram**: States and transitions
   - **Data flow**: How data moves through the system

4. Generate the mockup using ASCII art:
   - Use box-drawing characters: ┌ ┐ └ ┘ │ ─ ├ ┤ ┬ ┴ ┼
   - Use arrows: → ← ↑ ↓ ↔
   - Keep it readable at standard terminal width (80-120 chars)
   - Include annotations explaining interactive elements

5. Present to the user for feedback
6. Save approved mockup to `mockups/<name>.md` with:
   - Title and description
   - The ASCII mockup
   - Notes about interactions/behavior
   - Any open questions about the design
```
