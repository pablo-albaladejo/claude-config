---
name: root-cause
description: Exhaustive root cause analysis for production incidents. Orchestrates parallel investigations from multiple angles, synthesizes findings, and produces a structured report with defense-in-depth recommendations.
user-invocable: true
allowed-tools: Read, Glob, Grep, Task, Bash, WebFetch
---

# Root Cause Analysis

Perform an exhaustive root cause investigation for a production incident or bug.

## Input

- `<issue>`: Description of the incident, error message, Jira ticket URL, or Datadog alert

## Methodology

Launch **4 parallel investigation agents** (Explore type), each analyzing the problem from a different angle. Then synthesize all findings into a single structured report.

### Agent 1 — Error Site Investigation
Trace the exact code path where the error occurs:
- Read the failing function/service and its callers
- Follow the full call chain from entry point to failure
- Identify what validation, error handling, or guards exist (or are missing)
- Check database schemas, column constraints, API contracts

### Agent 2 — Data Source Investigation
Trace where the problematic data originates:
- Find the upstream producer of the data that caused the failure
- Check if there are configuration limits (max_tokens, timeouts, size limits)
- Read prompts, templates, or external API calls that generate the data
- Identify why the data exceeded expected bounds

### Agent 3 — Event Flow / Integration Investigation
Trace how data moves between components:
- Map the full pipeline (queues, topics, publishers, consumers)
- Check DTOs and Zod schemas at each boundary for validation gaps
- Compare validation between different paths to the same destination (e.g., REST API vs event-driven)
- Identify where data passes through without checks

### Agent 4 — Historical & Pattern Investigation
Search for existing defenses and prior incidents:
- Search for existing validation, truncation, or error handling patterns in the codebase
- Look for related past fixes, ticket references in comments, or migrations
- Check if other similar components have the same vulnerability
- Identify if the issue was partially addressed before but not fully resolved

## Output Format

After all agents complete, synthesize into this structure:

### 1. The Problem (one sentence)
Clear statement of the root cause.

### 2. Data Flow Diagram
ASCII diagram showing the full pipeline with failure point marked.

### 3. Layers Without Validation
Table showing each layer, file, line number, and what validation is missing.

### 4. Comparison Table
If multiple paths exist to the same destination, compare their validation (e.g., REST vs event-driven).

### 5. Failure Modes Observed
Numbered list of distinct ways the bug manifested in production, with concrete data.

### 6. Previous History
Any prior related fixes or migrations that addressed symptoms instead of root cause.

### 7. Recommended Fix — Defense in Depth
Ordered list of fixes at multiple layers (prompt/config, schema/validation, service/application), from outermost to innermost defense.

## Guidelines

- Be specific: include file paths, line numbers, exact field definitions
- Show the gap, not just describe it: quote the actual code (`z.string()` vs `z.string().max(255)`)
- Focus on the systemic pattern, not just the immediate error
- Check if the same vulnerability exists in similar components
- Write the report in the language the user is using in the conversation
