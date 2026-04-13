---
name: expert-panel
description: Multi-perspective review by 5 Principal/Staff-level experts with iterative convergence loop until target score is reached
triggers:
  - expert panel
  - panel review
  - review with 5 experts
  - multi-perspective review
  - review and fix until 9.5
  - expert panel review
  - staff review
---

# Expert Panel — Multi-Perspective Convergence Loop

Review any set of artifacts (OpenSpec proposals, code, PRs, architecture docs) from **5 Principal/Staff-level expert perspectives**, scoring each 1-10, then **iterate fixing issues until the average score exceeds a target threshold**.

---

## Input

The argument after `/expert-panel` can be:

- **A path or glob**: `openspec/changes/fix-release-workflow/` — review all artifacts in that directory
- **A PR number**: `#123` — review the PR diff
- **A file list**: `release.yml create-github-releases.js` — review specific files
- **Nothing**: review uncommitted changes in the working tree

Optional flags (append after the target):
- `--target=N` — set the target average score (default: **9.5**)
- `--roles="Role1,Role2,Role3,Role4,Role5"` — override the default 5 expert roles

---

## Default Expert Roles

The 5 roles are chosen **based on the artifact type**. Each role MUST represent **Principal/Staff+ seniority** — these are not junior reviewers. They bring 15+ years of deep expertise, have seen systems fail at scale, know the difference between theoretical best practice and what actually matters in production, and are not afraid to challenge assumptions. They review like someone whose name is on the architecture decision.

When announcing roles to the user, always use the senior title (e.g., "Principal CI/CD Engineer", "Staff Security Engineer"). Use the table below to select roles, or let the user override with `--roles`.

| Artifact Type | Role 1 | Role 2 | Role 3 | Role 4 | Role 5 |
|---------------|--------|--------|--------|--------|--------|
| CI/CD workflows | Principal CI/CD Engineer | Staff Security Engineer | Principal Release Engineer | Staff DX Engineer | Principal Architect |
| OpenSpec proposals | Principal Domain Expert | Staff Spec Analyst | Principal Task Reviewer | Staff Security Reviewer | Principal Consistency Reviewer |
| Application code | Principal Domain Expert | Staff Security Engineer | Principal Performance Engineer | Staff DX Engineer | Principal Architect |
| Frontend code | Principal UX Engineer | Staff Accessibility Expert | Principal Performance Engineer | Staff Security Engineer | Principal Architect |
| Infrastructure (CDK/TF) | Principal Cloud Engineer | Staff Security Engineer | Principal Cost Analyst | Staff Reliability Engineer | Principal Architect |
| API design | Principal API Engineer | Staff Security Engineer | Principal Performance Engineer | Staff DX Engineer | Principal Architect |
| Test suites | Principal Test Strategist | Staff Coverage Analyst | Principal Reliability Engineer | Staff DX Engineer | Principal Architect |

If the artifact spans multiple types, pick the 5 most relevant roles across categories (no duplicates). Always maintain the Principal/Staff seniority level regardless of how roles are combined.

---

## Workflow

### Step 1: Identify Artifacts & Select Roles

1. Read the target artifacts (files, PR diff, or uncommitted changes)
2. Also read relevant **context files** (the code being changed, configs, specs)
3. Determine artifact type and select 5 expert roles (or use user-provided roles)
4. Announce the roles and target to the user

### Step 2: Review (Dispatch to code-reviewer Agent)

Launch a **single `code-reviewer` agent** with a comprehensive prompt that:

1. Reads all artifact files and context files
2. Reviews from each of the 5 expert perspectives
3. For each role provides:
   - Key observations (strengths and issues)
   - Score (1-10)
   - Specific **actionable** improvements if score < 10
4. Classifies each finding as: `CRITICAL`, `IMPORTANT`, or `SUGGESTION`
5. Ends with:
   - Score table
   - Average score
   - Prioritized improvement list

### Step 3: Fix Issues

If average < target:

1. Parse the review findings
2. Fix **all CRITICAL and IMPORTANT issues** directly in the artifacts
3. Fix **SUGGESTIONS** that are low-effort and high-clarity
4. For each fix, make the minimal targeted edit (don't rewrite entire files)

### Step 4: Re-Review

Launch a new `code-reviewer` agent with:

- The same 5 roles
- Context of what was fixed since last review
- Instructions to be strict (only give 10 if truly flawless)

### Step 5: Loop or Finish

- If average >= target: **stop**, show final results
- If average < target: go back to Step 3
- **Safety limit**: max 10 iterations. If not converged after 10, stop and report

---

## Output Format

### During Iteration

Show a brief status after each review:

```
Iteration N: X.X/10 — [N issues remaining]. Fixing...
```

### Final Output

When target is reached (or max iterations hit), show:

**1. Score Progression Chart (ASCII art)**

```
  SCORE PROGRESSION
  ═══════════════════════════════════════════════
  
  10 ┤
     │                          ●  9.5
 9.5 ┤
     │         ●  ●  ●  ●  ●
   9 ┤
     │
 8.5 ┤
     │    ●
   8 ┤
     │
 7.5 ┤
     │
   7 ┤
     │
 6.5 ┤
     │  ●
   6 ┤
     └──┬──┬──┬──┬──┬──┬──
        1  2  3  4  5  6   iteration
```

**2. Final Score Table**

```markdown
| Role | Final Score |
|------|-------------|
| Role 1 | X/10 |
| Role 2 | X/10 |
| Role 3 | X/10 |
| Role 4 | X/10 |
| Role 5 | X/10 |
| **Average** | **X.X/10** |
```

**3. Key Improvements Summary**

Bullet list of the most impactful fixes made across all iterations.

---

## Review Prompt Template

Use this template when dispatching the `code-reviewer` agent:

```
Review [ARTIFACT DESCRIPTION] at [PATHS].

[IF ITERATION > 1:]
This is iteration N of a review cycle targeting [TARGET]+. Previous scores: [SCORE HISTORY].
Fixes since last review: [BULLET LIST OF FIXES]

Read ALL of these files:
[ARTIFACT FILE LIST]

Also read for context:
[CONTEXT FILE LIST]

Review from 5 expert perspectives. Each reviewer is a Principal/Staff-level engineer with 15+ years of experience — they have deep expertise, have seen systems fail at scale, and review with the rigor of someone whose reputation is on the line. Score each 1-10. Be strict — only give 10 if truly flawless.

### 1. [ROLE 1]
### 2. [ROLE 2]
### 3. [ROLE 3]
### 4. [ROLE 4]
### 5. [ROLE 5]

For each role provide:
- Key observations (strengths and any remaining issues)
- Score (1-10)
- Specific actionable improvements if score < 10

Classify findings as: CRITICAL (functional correctness), IMPORTANT (completeness/robustness), SUGGESTION (polish/edge cases).

End with average score. If average >= [TARGET], state "TARGET REACHED".
```

---

## Guardrails

- **Don't lower standards**: Never skip issues to reach the target faster
- **Don't inflate scores**: The reviewer agent must be strict and independent
- **Don't rewrite everything**: Make minimal, targeted fixes per iteration
- **Don't loop forever**: Max 10 iterations, then report honestly
- **Preserve user edits**: If the user modifies files between iterations, incorporate their changes
- **Ask before big changes**: If a fix requires significant restructuring, ask the user first
- **Track what was fixed**: Each iteration must list what changed since the last review
