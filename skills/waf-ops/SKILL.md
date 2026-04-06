---
name: waf-ops
description: Well-Architected Operational Excellence pillar - OPS 1-11, observability, CI/CD, deployment safety, continuous improvement
triggers:
  - operational excellence
  - observability
  - deployment risk
  - runbooks
  - operational readiness
---

# WAF Pillar: Operational Excellence (OPS)

Ability to support development, run workloads effectively, gain operational insights, and continuously improve.

## Design Principles

- Perform operations as code
- Make frequent, small, reversible changes
- Refine operations procedures frequently
- Anticipate failure
- Learn from all operational failures

---

## Organization

### OPS 1. How do you determine what your priorities are?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| OPS01-BP01 | Evaluate external customer needs | Documented process mapping stakeholder requirements to architectural features. Business outcomes drive technical priorities. |
| OPS01-BP02 | Evaluate internal customer needs | Feedback loop exists between devs, ops, and business. Internal requirements (logging, deploy speed) prioritized alongside features. |
| OPS01-BP03 | Evaluate governance requirements | Registry of internal policies exists. Architectural decisions trace back to governance mandates. |
| OPS01-BP04 | Evaluate compliance requirements | Up-to-date compliance matrix aligns technical controls with legal obligations (PCI-DSS, HIPAA, etc.). |
| OPS01-BP05 | Evaluate threat landscape | Regular security threat review for the business sector. Priority list includes mitigations for active threats. |
| OPS01-BP06 | Evaluate tradeoffs | ADRs document risk acknowledgment (speed vs. stability). Explicit trade-off rationale exists. |

### OPS 2. How do you structure your organization to support business outcomes?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| OPS02-BP01 | Resources have identified owners | 100% tagging compliance for ownership or automated inventory linking resources to teams/cost centers. |
| OPS02-BP02 | Processes have identified owners | Every Runbook has current "last reviewed by" and "owner" fields. |
| OPS02-BP03 | Operations activities have owners | SLOs defined for ops teams with clear accountability. |
| OPS02-BP04 | Mechanisms to manage ownership | Formal process for ownership transfer. No "orphan" resources during personnel transitions. |
| OPS02-BP05 | Mechanisms for additions/changes/exceptions | Centralized ticketing or API-driven workflow. No shadow IT. |
| OPS02-BP06 | Responsibilities predefined between teams | RACI matrix or SLAs between internal teams exist. |

### OPS 3. How does organizational culture support business outcomes?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| OPS03-BP01 | Executive sponsorship | Budget allocated for non-feature work (tech debt reduction). |
| OPS03-BP02 | Empowered to take action | Any team member can stop a deployment or escalate without fear. |
| OPS03-BP03 | Escalation encouraged | Defined escalation path. Escalations lead to documented resolution or risk acceptance. |
| OPS03-BP04 | Timely, clear communications | Standardized channels. Status page or automated notifications for workload health. |
| OPS03-BP05 | Experimentation encouraged | Sandbox environments available. Failed experiments tracked as learning metrics. |
| OPS03-BP06 | Skill growth encouraged | Learning hours or certification programs. Demonstrable technical growth. |
| OPS03-BP07 | Teams resourced appropriately | Velocity and burnout monitored. Capacity exists for operational excellence. |

---

## Prepare

### OPS 4. How do you implement observability?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| OPS04-BP01 | Identify KPIs | Business-reflecting metrics (e.g., orders/minute) documented and visualized. |
| OPS04-BP02 | Application telemetry | App-level errors identifiable without looking at infrastructure logs. |
| OPS04-BP03 | User experience telemetry | RUM or synthetic transactions show exactly what users experience during latency events. |
| OPS04-BP04 | Dependency telemetry | External APIs and DBs monitored. Can quickly determine if failure is internal or third-party. |
| OPS04-BP05 | Distributed tracing | Request traceable across all service boundaries (e.g., X-Ray). Full call stack visible for any single request. |

### OPS 5. How do you reduce defects and improve flow into production?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| OPS05-BP01 | Version control | Can recreate entire environment from a single Git hash? |
| OPS05-BP02 | Test and validate changes | Code cannot reach production without passing automated test suite. |
| OPS05-BP03 | Configuration management | Manual configuration on servers is strictly forbidden and technically prevented. |
| OPS05-BP04 | Build and deployment systems | CI/CD pipeline exists. Measured by deployment frequency and lack of manual steps. |
| OPS05-BP05 | Patch management | Automated mechanism to identify and update out-of-date dependencies/OS versions. |
| OPS05-BP06 | Share design standards | Golden Paths or standardized templates. New projects start from approved foundations. |
| OPS05-BP07 | Code quality practices | Linting, static analysis, peer reviews integrated into PR process. |
| OPS05-BP08 | Multiple environments | Staging/UAT before production. Staging architecturally identical to production. |
| OPS05-BP09 | Frequent, small, reversible changes | High deployment frequency. Any change reversible in minutes. |
| OPS05-BP10 | Fully automate integration and deployment | Zero-touch deployment. Code commit triggers automated path to production. |

### OPS 6. How do you mitigate deployment risks?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| OPS06-BP01 | Plan for unsuccessful changes | Pre-defined rollback plan. Team can document exact "point of no return." |
| OPS06-BP02 | Test deployments | Health checks verify service availability post-deployment. |
| OPS06-BP03 | Safe deployment strategies | Canary or Blue/Green. Traffic shifts incrementally while monitoring errors. |
| OPS06-BP04 | Automate testing and rollback | Monitoring auto-triggers rollback when health metrics drop during deployment. |

### OPS 7. How do you know you are ready to support a workload?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| OPS07-BP01 | Personnel capability | Skills matrix proves team expertise for the workload's technologies. |
| OPS07-BP02 | Operational readiness review | Signed-off ORR checklist before every major launch. |
| OPS07-BP03 | Runbooks for procedures | New team member can perform task using only the runbook. |
| OPS07-BP04 | Playbooks for investigations | Decision trees for common failure modes (high CPU, 5xx errors). |
| OPS07-BP05 | Informed deploy decisions | CI/CD checks system health before initiating a push. |
| OPS07-BP06 | Support plans for production | 24/7 on-call rotation. Support contract matches workload criticality. |

---

## Operate

### OPS 8. How do you utilize workload observability?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| OPS08-BP01 | Analyze metrics | Weekly or monthly reviews of metric patterns and trends. |
| OPS08-BP02 | Analyze logs | Automated log aggregation with query and alert capabilities (CloudWatch Logs Insights). |
| OPS08-BP03 | Analyze traces | Developers use trace data to optimize specific code paths. |
| OPS08-BP04 | Actionable alerts | Every alert links to a playbook. Alerts without playbooks are noise. |
| OPS08-BP05 | Dashboards | Both technical health (CPU/Memory) and business health (Revenue/Users) dashboards exist. |

### OPS 9. How do you understand operations health?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| OPS09-BP01 | Measure operations KPIs | MTTR and other operational metrics tracked alongside workload metrics. |
| OPS09-BP02 | Communicate status and trends | Regular reports to leadership on availability and incident trends. |
| OPS09-BP03 | Review and prioritize improvements | Prioritized backlog derived from operational data exists. |

### OPS 10. How do you manage workload and operations events?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| OPS10-BP01 | Event/incident/problem management process | Clear history from detection to resolution for any incident. |
| OPS10-BP02 | Process per alert | Alert notification contains link to resolution instructions. |
| OPS10-BP03 | Prioritize by business impact | Severity system (Sev1-Sev3) dictates response speed and resources. |
| OPS10-BP04 | Escalation paths | Documented escalation matrix with contacts and response time expectations. |
| OPS10-BP05 | Customer communication plan | Pre-written template and platform (status page) for customer notifications. |
| OPS10-BP06 | Status dashboards during events | "War Room" dashboard for incident-specific telemetry. |
| OPS10-BP07 | Automate responses | Self-healing: auto-restart hung processes, auto-scale on error spikes. |

---

## Evolve

### OPS 11. How do you evolve operations?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| OPS11-BP01 | Continuous improvement process | Specific operational changes in last quarter based on past data. |
| OPS11-BP02 | Post-incident analysis | Blameless Post-Mortems with actionable prevention items. |
| OPS11-BP03 | Feedback loops | Formal mechanism turning stakeholder/user feedback into backlog items. |
| OPS11-BP04 | Knowledge management | Searchable, regularly updated internal Wiki/docs portal. |
| OPS11-BP05 | Define improvement drivers | Improvements driven by data (error rates, developer velocity). |
| OPS11-BP06 | Validate insights | Pilot programs or small-scale trials before major operational changes. |
| OPS11-BP07 | Operations metrics reviews | KPIs and alerts audited and refined at least annually. |
| OPS11-BP08 | Document and share lessons learned | Cross-team learning sessions or newsletters exist. |
| OPS11-BP09 | Allocate time for improvements | 10-20% of team capacity dedicated to operational improvement vs. new features. |
