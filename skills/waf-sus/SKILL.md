---
name: waf-sus
description: Well-Architected Sustainability pillar - SUS 1-6, environmental impact, resource efficiency, demand alignment
triggers:
  - sustainability pillar
  - environmental impact
  - carbon footprint
  - green cloud
  - energy efficiency
---

# WAF Pillar: Sustainability (SUS)

Minimize the environmental impact of running cloud workloads through shared responsibility.

## Design Principles

- Understand your impact
- Establish sustainability goals
- Maximize utilization
- Anticipate and adopt new, more efficient hardware and software offerings
- Use managed services
- Reduce the downstream impact of your cloud workloads

---

## Region Selection

### SUS 1. How do you select Regions?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| SUS01-BP01 | Region based on sustainability goals | Favor regions with higher renewable energy mix. Sustainability is a documented factor in region selection. |

---

## Alignment to Demand

### SUS 2. How do you align cloud resources to demand?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| SUS02-BP01 | Dynamic scaling | Auto Scaling shrinks environment during low-usage periods. Only use what you need. |
| SUS02-BP02 | Align SLAs with sustainability | Lower SLAs agreed for non-critical apps to save energy. Not everything needs 99.99%. |
| SUS02-BP03 | Stop unused assets | No EBS volumes unattached for >30 days. Orphaned resources deleted. |
| SUS02-BP04 | Optimize geographic placement | Compute near data source or user. Minimize network energy from distance. |
| SUS02-BP05 | Optimize team resources | Automation reduces carbon footprint of manual operations. Code-driven workflows. |
| SUS02-BP06 | Buffer/throttle demand curve | Queues process work at steady rate. No massive peaks requiring high-capacity idle hardware. |

---

## Software and Architecture

### SUS 3. How do you leverage software and architecture patterns?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| SUS03-BP01 | Async job optimization | Batch jobs scheduled for off-peak hours or cleanest grid periods. |
| SUS03-BP02 | Remove low/no-use components | Dead code analysis performed. Unused features decommissioned. |
| SUS03-BP03 | Optimize high-resource code | Profiling tools used to optimize high-resource functions. Efficient code = less CPU. |
| SUS03-BP04 | Optimize device impact | Application optimized for low-bandwidth/low-power consumption. Less data sent to user devices. |
| SUS03-BP05 | Efficient data access patterns | Caching and efficient serialization (e.g., Parquet). Minimize disk reads. |

---

## Data

### SUS 4. How do you leverage data management policies?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| SUS04-BP01 | Data classification policy | Data tagged by importance. |
| SUS04-BP02 | Right storage tier | S3 Glacier for archive, S3 Lifecycle policies in place. |
| SUS04-BP03 | Dataset lifecycle policies | Auto-delete unneeded data. "Temp" data stored >24 hours? Non-compliant. |
| SUS04-BP04 | Elastic block storage | Thin provisioning or automated volume expansion. Don't provision 1TB for 10GB. |
| SUS04-BP05 | Remove redundant data | Deduplication process. Duplicate backups/logs found and removed. |
| SUS04-BP06 | Shared file systems | Amazon EFS/FSx for common data. Avoid copying same data to 100 servers. |
| SUS04-BP07 | Minimize data movement | In-place processing (S3 Select, Redshift Spectrum). Processing close to data. |
| SUS04-BP08 | Back up only non-reproducible data | Backup policy excludes scratch/reproducible data. |

---

## Hardware and Services

### SUS 5. How do you select hardware and services?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| SUS05-BP01 | Minimum hardware | Right-sized. CPU/RAM utilization consistently high, not 5%. |
| SUS05-BP02 | Least-impact instance types | Graviton processors used. More energy-efficient than x86. |
| SUS05-BP03 | Managed services | Serverless (Lambda, Fargate) preferred over EC2. AWS optimizes underlying hardware. |
| SUS05-BP04 | Optimize accelerator usage | GPUs only when necessary, high utilization. Released immediately after training jobs. |

---

## Process and Culture

### SUS 6. How do organizational processes support sustainability?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| SUS06-BP01 | Sustainability goals communicated | Documented sustainability KPIs. Every developer knows the goal. |
| SUS06-BP02 | Rapid sustainability improvements | CI/CD pushes efficiency gains. Code optimization deployed in minutes. |
| SUS06-BP03 | Keep workload up-to-date | Regular patching and version upgrades. Newer software is more efficient. |
| SUS06-BP04 | Build environment utilization | CI/CD runners shared across teams. Build servers not sitting idle. |
| SUS06-BP05 | Managed device farms | AWS Device Farm instead of physical phones. |
