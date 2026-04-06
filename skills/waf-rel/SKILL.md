---
name: waf-rel
description: Well-Architected Reliability pillar - REL 1-13, fault isolation, DR, static stability, chaos engineering
triggers:
  - reliability pillar
  - fault tolerance
  - disaster recovery
  - high availability
  - resilience
  - failover
---

# WAF Pillar: Reliability (REL)

Workload performs its intended function correctly and consistently. Design for "Static Stability" - systems work even when dependencies are impaired.

## Design Principles

- Automatically recover from failure
- Test recovery procedures
- Scale horizontally to increase aggregate availability
- Stop guessing capacity
- Manage change in automation

---

## Foundations

### REL 1. How do you manage Service Quotas and constraints?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| REL01-BP01 | Aware of quotas | List of all relevant service quotas maintained for the architecture. |
| REL01-BP02 | Manage quotas across accounts/regions | Centralized view of limits across entire organization. |
| REL01-BP03 | Accommodate fixed quotas through architecture | Multiple accounts or regions used to bypass hard limits. |
| REL01-BP04 | Monitor quotas | CloudWatch Alarms at 80% of quota. Never discover limits from failed requests. |
| REL01-BP05 | Automate quota management | Service Quotas API for automatic increase requests via IaC. |
| REL01-BP06 | Gap for failover | Quotas set to at least 2x peak requirements to accommodate AZ loss. |

### REL 2. How do you plan network topology?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| REL02-BP01 | HA for public endpoints | Route 53 + CloudFront. Multi-region or multi-AZ DNS failover. |
| REL02-BP02 | Redundant private connectivity | Multiple Direct Connects or DX + VPN. Cut one line; system stays up. |
| REL02-BP03 | IP subnet expansion | Subnets have at least 25% free space for scaling and failover. |
| REL02-BP04 | Hub-and-spoke over mesh | Transit Gateway. Simplified routing, no loops. |
| REL02-BP05 | Non-overlapping IP ranges | Centralized IPAM. VPCs don't clash with on-prem. |

---

## Workload Architecture

### REL 3. How do you design service architecture?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| REL03-BP01 | Segment workload | Microservices or cells limit blast radius. One component failure doesn't crash the app. |
| REL03-BP02 | Domain-focused services | Services decoupled. Can update independently. |
| REL03-BP03 | Service contracts per API | Versioned APIs (/v1/, /v2/). Can deploy new version without forcing consumer updates. |

### REL 4. How do you prevent failures in distributed systems?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| REL04-BP01 | Identify dependency types | Every dependency mapped with failure mode understood (hard vs. soft). |
| REL04-BP02 | Loosely coupled dependencies | SQS/EventBridge. Producer doesn't need consumer online. |
| REL04-BP03 | Constant work | Steady-rate background tasks. No "thundering herd" from spiky workloads. |
| REL04-BP04 | Idempotent mutations | Calling API twice = same effect as once. Retries don't create duplicates. |

### REL 5. How do you mitigate/withstand failures in distributed systems?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| REL05-BP01 | Graceful degradation | Non-critical service failure doesn't cause 500 errors. UI handles it. |
| REL05-BP02 | Throttle requests | Rate-limiting at API Gateway level. |
| REL05-BP03 | Control retries | Exponential Backoff + Jitter. Retries staggered, not overwhelming. |
| REL05-BP04 | Fail fast, limit queues | Aggressive timeouts. Deep queues avoided. |
| REL05-BP05 | Client timeouts | Every network call has a timeout parameter. Check every API call in code. |
| REL05-BP06 | Stateless where possible | Session in DynamoDB/ElastiCache, not on server. Any instance terminable without user impact. |
| REL05-BP07 | Emergency levers | Kill switch for high-risk features via config flag. |

---

## Change Management

### REL 6. How do you monitor workload resources?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| REL06-BP01 | Monitor all components | Every component has at least one health metric. |
| REL06-BP02 | Define metrics | Defined thresholds for "unhealthy" (e.g., Error Rate %). |
| REL06-BP03 | Send notifications | Alarm triggers notification to on-call via SNS/PagerDuty. |
| REL06-BP04 | Automate responses | Auto Scaling or Lambda fixes disk-full/high-CPU without human. |
| REL06-BP05 | Analyze logs | Team reviews log trends weekly. |
| REL06-BP06 | Review monitoring scope | Monitoring config is part of code review process. |
| REL06-BP07 | End-to-end tracing | Developers use X-Ray traces to fix high-latency components. |

### REL 7. How do you adapt to demand changes?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| REL07-BP01 | Automated scaling | No human needed to "add a server" during peak. |
| REL07-BP02 | Replace impaired resources | Terminate random instance; system replaces it automatically. |
| REL07-BP03 | Scale on demand detection | Scaling triggered by performance metrics (CPU > 70%). |
| REL07-BP04 | Load test | System tested to at least 2x expected peak load. |

### REL 8. How do you implement change?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| REL08-BP01 | Runbooks for standard activities | Deployment process documented and followed. |
| REL08-BP02 | Functional testing in deployment | Pipeline runs smoke tests post-deployment. |
| REL08-BP03 | Resiliency testing in deployment | Game Days performed in staging. |
| REL08-BP04 | Immutable infrastructure | Never patch live servers. Deploy new ones. No SSH keys for production. |
| REL08-BP05 | Automated change deployment | 100% of production changes via CI/CD pipeline. |

---

## Failure Management

### REL 9. How do you back up data?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| REL09-BP01 | Identify and back up all data | Inventory of all data stores and their backup status. |
| REL09-BP02 | Secure and encrypt backups | Backups in different account with WORM locks. |
| REL09-BP03 | Automatic backup | AWS Backup scheduled. No human intervention needed. |
| REL09-BP04 | Periodic recovery testing | Can restore database to point-in-time from 3 days ago in <2 hours. |

### REL 10. How do you use fault isolation?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| REL10-BP01 | Multiple locations | Multi-AZ or multi-Region. Survives total failure of one AZ. |
| REL10-BP02 | Automate single-location recovery | Single-AZ components auto-failover to another AZ. Hands-off. |
| REL10-BP03 | Bulkhead architectures | Shuffle sharding or cell-based. One customer/service failure doesn't take down others. |

### REL 11. How do you withstand component failures?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| REL11-BP01 | Monitor all components | Every resource covered by a health check. |
| REL11-BP02 | Fail over to healthy resources | Route 53 or ELB shifts traffic. Failover in seconds. |
| REL11-BP03 | Automate healing on all layers | System detects hangs and auto-restarts. OS through application. |
| REL11-BP04 | Data plane over control plane | System stays up even if AWS API is unavailable. Failover works without Management Console. |
| REL11-BP05 | Static stability | Pre-provisioned capacity in all AZs. No AWS API call needed to scale during failover. |
| REL11-BP06 | Notifications on availability impact | Every failover triggers high-priority alert. |
| REL11-BP07 | Architect for availability targets | Availability math calculation performed for entire stack (e.g., 99.9%). |

### REL 12. How do you test reliability?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| REL12-BP01 | Playbooks for failures | Playbooks exist for top 5 failure modes. |
| REL12-BP02 | Post-incident analysis | Library of Post-Mortems with completed action items. |
| REL12-BP03 | Scalability/performance testing | Regular load testing. |
| REL12-BP04 | Chaos engineering | AWS Fault Injection Service (FIS) used regularly. |
| REL12-BP05 | Regular game days | Full-scale failure simulation at least quarterly. |

### REL 13. How do you plan for DR?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| REL13-BP01 | Define RTO/RPO | Business-agreed recovery objectives documented. |
| REL13-BP02 | Defined recovery strategy | Pilot Light, Warm Standby, or Active/Active. Implementation matches strategy. |
| REL13-BP03 | Test DR | Can failover to another region and run production for 24 hours. |
| REL13-BP04 | Manage DR config drift | Same IaC templates for both regions. DR site mirrors production. |
| REL13-BP05 | Automate recovery | Single script or event triggers DR failover. Not a 40-step manual process. |
