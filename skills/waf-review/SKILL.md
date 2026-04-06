---
name: waf-review
description: AWS Well-Architected Framework full review - dispatches all 6 pillar assessments in parallel
triggers:
  - well-architected review
  - WAF review
  - architectural review
  - pillar review
---

# AWS Well-Architected Framework Review

Orchestrates a comprehensive review of the workload against all 6 pillars of the AWS Well-Architected Framework.

## Framework Fundamentals

The WAF is a structured conversation to evaluate architectural health. It is grounded in 6 General Design Principles:

1. **Stop guessing capacity needs** - Use cloud elasticity
2. **Test systems at production scale** - Spin up full-scale temporary environments
3. **Automate architectural experimentation** - Changes through code
4. **Allow evolutionary architectures** - Design for change
5. **Drive architectures using data** - Decisions from workload metrics
6. **Improve through game days** - Simulate failures regularly

## Pillar Summary

| Pillar | Skill | Questions | Best Practices | Focus Areas |
|--------|-------|-----------|----------------|-------------|
| Operational Excellence | `waf-ops` | OPS 1-11 | 53 | Organization, Prepare, Operate, Evolve |
| Security | `waf-sec` | SEC 1-11 | 63 | Foundations, Identity, Detection, Protection, Data, IR |
| Reliability | `waf-rel` | REL 1-13 | 63 | Foundations, Architecture, Change Mgmt, Failure Mgmt |
| Performance Efficiency | `waf-perf` | PERF 1-5 | 32 | Selection, Compute, Data, Networking, Culture |
| Cost Optimization | `waf-cost` | COST 1-11 | 51 | CFM, Awareness, Resources, Demand/Supply, Optimization |
| Sustainability | `waf-sus` | SUS 1-6 | 29 | Region, Demand, Software, Data, Hardware, Culture |

## Review Workflow

### Step 1: Scope

Ask the user:
- What is the workload being reviewed? (specific service, full platform, infra change)
- Any pillar priority? (default: all 6)
- Review depth: **quick** (design principles + key litmus tests) or **full** (all BPs)?

### Step 2: Dispatch Pillar Assessments

Launch 6 parallel agents, one per pillar skill. Each agent receives:
- The workload scope from Step 1
- The review depth
- Instructions to evaluate the codebase/infrastructure against that pillar's best practices

```
Dispatch in parallel:
- Agent 1: Invoke waf-ops skill against the workload
- Agent 2: Invoke waf-sec skill against the workload
- Agent 3: Invoke waf-rel skill against the workload
- Agent 4: Invoke waf-perf skill against the workload
- Agent 5: Invoke waf-cost skill against the workload
- Agent 6: Invoke waf-sus skill against the workload
```

Each agent should:
1. Read the relevant pillar skill for the complete BP reference
2. Examine the codebase, CDK stacks, configs, and tests
3. Return findings as: `{compliant, needs_attention, non_compliant, not_applicable}` per foundational question

### Step 3: Synthesize Report

Combine all 6 pillar reports into a unified assessment:

```markdown
# Well-Architected Review: [Workload Name]
**Date:** YYYY-MM-DD
**Scope:** [description]
**Depth:** quick | full

## Executive Summary
- Overall health: [RED/YELLOW/GREEN]
- Critical findings: N
- Improvement opportunities: N

## Pillar Scores
| Pillar | Status | Critical | Improvements | N/A |
|--------|--------|----------|-------------|-----|
| OPS    | ...    | ...      | ...         | ... |
| SEC    | ...    | ...      | ...         | ... |
| REL    | ...    | ...      | ...         | ... |
| PERF   | ...    | ...      | ...         | ... |
| COST   | ...    | ...      | ...         | ... |
| SUS    | ...    | ...      | ...         | ... |

## Critical Findings (must fix)
1. ...

## Improvement Opportunities (should fix)
1. ...

## Trade-offs Acknowledged
1. ...
```

### Step 4: Action Items

Generate prioritized action items grouped by:
1. **Quick wins** - Low effort, high impact
2. **Strategic improvements** - High effort, high impact
3. **Technical debt** - Defer with documented risk acceptance

## Important Notes

- This is a constructive conversation, not an audit. Acknowledge intentional trade-offs (e.g., PoC/MVP stages justify skipping some BPs).
- Always check ADRs in `specs/architecture/decisions/` for documented trade-off rationale.
- For this project's stage (Platform, post-MVP), focus on BPs that protect production reliability and security over organizational maturity BPs.
