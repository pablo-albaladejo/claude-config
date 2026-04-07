# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture

Follow hexagonal architecture (ports & adapters) strictly:

- **Domain**: Pure business logic. No imports from infrastructure, frameworks, or external libraries. Only depends on its own ports (interfaces).
- **Application**: Use cases / services. Orchestrates domain. Depends on domain ports, never on adapters.
- **Infrastructure**: Adapters (DB, HTTP, queues, external APIs). Implements domain ports. Never imported by domain or application.

Before writing or modifying code, verify layer boundaries are not violated. A domain module must never import from infrastructure. An application service must never instantiate an adapter directly — always inject through ports.

## Specs

`openspec/specs/` contains the living documentation of the system's capabilities — what the system does today, expressed as requirements and scenarios. Each subdirectory is one capability. Read them before proposing changes to understand current behavior. Update them when a change alters existing behavior.

## Testing

Follow TDD strictly: write the failing test first, then the minimal code to pass it, then refactor.

- Every public function, use case, and adapter has a test.
- Never delete a test. Never skip a test. If a test fails, fix the code or update the test to reflect a deliberate behavior change — never silence it.
- Domain logic is tested with unit tests (no mocks needed — pure functions).
- Application services are tested with ports mocked/stubbed.
- Adapters are tested with integration tests against real dependencies.

## Debugging

When something fails, find the root cause. Do not patch symptoms. Trace the error back to its origin, understand why it happens, and fix it there.

## Skills

### OpenSpec workflow (`/opsx-*`)

Structured change management: explore ideas, propose changes, implement, verify, and archive.

- `/opsx-explore` — Thinking partner. Explore ideas, investigate problems, clarify requirements before coding.
- `/opsx-propose` — Generate a complete change proposal (design, specs, tasks) in one step.
- `/opsx-apply` — Implement tasks from a proposed change.
- `/opsx-verify` — Verify implementation against spec scenarios and acceptance criteria.
- `/opsx-sync` — Sync domain specs with current codebase state after refactors.
- `/opsx-archive` — Archive a completed change.

### AWS Well-Architected Framework (`/waf-*`)

Review workloads against the 6 WAF pillars.

- `/waf-review` — Full review, dispatches all 6 pillars in parallel.
- `/waf-ops` — Operational Excellence (OPS 1-11)
- `/waf-sec` — Security (SEC 1-11)
- `/waf-rel` — Reliability (REL 1-13)
- `/waf-perf` — Performance Efficiency (PERF 1-5)
- `/waf-cost` — Cost Optimization (COST 1-11)
- `/waf-sus` — Sustainability (SUS 1-6)
