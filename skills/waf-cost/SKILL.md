---
name: waf-cost
description: Well-Architected Cost Optimization pillar - COST 1-11, FinOps, resource selection, pricing models, demand management
triggers:
  - cost optimization pillar
  - FinOps
  - cloud financial management
  - cost governance
  - pricing models
  - data transfer cost
---

# WAF Pillar: Cost Optimization (COST)

Achieve business value at the lowest price point through Cloud Financial Management (CFM). Not just saving money - maximizing value.

## Design Principles

- Implement Cloud Financial Management
- Adopt a consumption model
- Measure overall efficiency
- Stop spending money on undifferentiated heavy lifting
- Analyze and attribute expenditure

---

## Practice Cloud Financial Management

### COST 1. How do you implement cloud financial management?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| COST01-BP01 | Cost optimization ownership | Person or team responsible for the cloud bill assigned. |
| COST01-BP02 | Finance-technology partnership | Monthly FinOps meetings between finance and tech teams. |
| COST01-BP03 | Budgets and forecasts | AWS Budgets with 12-month forecast. |
| COST01-BP04 | Cost awareness in processes | ADRs include "Estimated Monthly Cost" section. |
| COST01-BP05 | Cost reporting | Automated weekly spending summary to team. |
| COST01-BP06 | Proactive cost monitoring | Cost Explorer alarm for Cost Anomalies on unexpected spikes. |
| COST01-BP07 | Track new service releases | Quarterly reviews of instance pricing (e.g., m5 → m6g). |
| COST01-BP08 | Cost-aware culture | "Savings from Optimization" tracked as success metric. |
| COST01-BP09 | Quantify business value | Cost per transaction measured. Bill up 10% but revenue up 50% = optimized. |

---

## Expenditure and Usage Awareness

### COST 2. How do you govern usage?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| COST02-BP01 | Policies from org requirements | SCPs enforce rules (e.g., "Only t3.medium in Dev"). |
| COST02-BP02 | Goals and targets | Efficiency targets: reduce unused Elastic IPs, orphaned snapshots. |
| COST02-BP03 | Account structure | AWS Organizations for billing isolation. Each department has own account/cost center. |
| COST02-BP04 | Groups and roles | IAM controls who launches expensive resources. Only senior architects launch 24xlarge. |
| COST02-BP05 | Cost controls | AWS Budgets with active alerts on every project. |
| COST02-BP06 | Track project lifecycle | Dev environments have "Scheduled Shutdown" or expiration dates. |

### COST 3. How do you monitor cost and usage?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| COST03-BP01 | Detailed information sources | Cost and Usage Report (CUR) enabled with granular data in S3. |
| COST03-BP02 | Organization info in cost data | Cost Allocation Tags. Can identify which team spent $50 on DynamoDB yesterday. |
| COST03-BP03 | Cost attribution categories | 100% of bill attributed to a cost center via tags. |
| COST03-BP04 | Organization metrics | "Cost per Daily Active User" reportable. |
| COST03-BP05 | Billing tools configured | Cost Explorer + Compute Optimizer reviewed monthly. |
| COST03-BP06 | Workload-based cost allocation | Shared resources (central DB) allocated by usage. Fair split. |

### COST 4. How do you decommission resources?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| COST04-BP01 | Track resource lifetime | Every resource identified with its purpose. |
| COST04-BP02 | Decommissioning process | Sunsetting checklist: IPs, Volumes, DNS removed when project ends. |
| COST04-BP03 | Manual decommission | Monthly "Cleanup Day" performed. |
| COST04-BP04 | Automatic decommission | TTL tags + Lambda delete dev environments on weekends. |
| COST04-BP05 | Data retention policies | S3 lifecycle deletes logs after 30 days unless compliance requires longer. |

---

## Cost-Effective Resources

### COST 5. How do you evaluate cost when selecting services?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| COST05-BP01 | Org requirements for cost | "Value vs. Cost" priority documented. |
| COST05-BP02 | Analyze all components | Cost breakdown per layer (compute, storage, networking). |
| COST05-BP03 | Thorough component analysis | TCO calculated (e.g., RDS vs. self-managed DB). |
| COST05-BP04 | Cost-effective licensing | Open-source or AWS-provided licenses over "per-core." |
| COST05-BP05 | Optimize component selection | Managed services (SQS vs. custom queue) to reduce operational labor cost. |
| COST05-BP06 | Cost analysis over time | Cost-scaling model exists (1K vs. 1M users). |

### COST 6. How do you meet cost targets for resource selection?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| COST06-BP01 | Cost modeling | Every design includes AWS Pricing Calculator estimate. |
| COST06-BP02 | Data-based resource selection | Server size chosen based on load test results, not guessing. |
| COST06-BP03 | Automatic resource selection | AWS Compute Optimizer recommendations acted on. Over-provisioned instances downsized. |
| COST06-BP04 | Shared resources | Multi-tenant DB for small services. Small workloads consolidated where appropriate. |

### COST 7. How do you use pricing models to reduce cost?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| COST07-BP01 | Pricing model analysis | Mix of On-Demand, Savings Plans, Spot based on workload stability. |
| COST07-BP02 | Region selection by cost | Region choice included cost comparison. |
| COST07-BP03 | Third-party cost efficiency | Marketplace purchases reviewed for value. |
| COST07-BP04 | Pricing models for all components | ≥70% of steady-state covered by Savings Plan or RI. |
| COST07-BP05 | Management account analysis | Monthly review of organization-level consolidated billing savings. |

### COST 8. How do you plan for data transfer charges?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| COST08-BP01 | Data transfer modeling | Cross-AZ and internet egress costs estimated. |
| COST08-BP02 | Optimize data transfer components | VPC Endpoints avoid NAT Gateway charges. Internal traffic on AWS private network. |
| COST08-BP03 | Reduce data transfer costs | CloudFront for egress. Paying more for NAT Gateway than DB? Non-compliant. |

---

## Manage Demand and Supply

### COST 9. How do you manage demand and supply resources?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| COST09-BP01 | Workload demand analysis | Usage pattern graph over a week. Peak hours known. |
| COST09-BP02 | Buffer/throttle for demand | SQS smooths spikes. No need to scale to absolute peak of momentary burst. |
| COST09-BP03 | Dynamic resource supply | Scheduled or Predictive Scaling. System pre-scales before known daily peak. |

---

## Optimize Over Time

### COST 10. How do you evaluate new services?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| COST10-BP01 | Workload review process | Well-Architected Review scheduled every 6-12 months. |
| COST10-BP02 | Regular workload analysis | Legacy components migrated to modern, cheaper services. |

### COST 11. How do you evaluate the cost of effort?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| COST11-BP01 | Automate operations | Engineer's time cost weighed against cloud resource cost. Manual tasks automated. |
