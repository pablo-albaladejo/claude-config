---
name: waf-perf
description: Well-Architected Performance Efficiency pillar - PERF 1-5, compute selection, data management, networking, performance culture
triggers:
  - performance efficiency
  - performance pillar
  - right-sizing
  - latency optimization
  - compute selection
---

# WAF Pillar: Performance Efficiency (PERF)

Use computing resources efficiently to meet requirements and maintain efficiency as technology evolves.

## Design Principles

- Democratize advanced technologies
- Go global in minutes
- Use serverless architectures
- Experiment more often
- Consider mechanical sympathy

---

## Architecture Selection

### PERF 1. How do you select appropriate cloud resources and architecture?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| PERF01-BP01 | Learn available cloud services | Documented quarterly reviews of new service features. |
| PERF01-BP02 | Use provider guidance | Architecture reviewed against AWS reference architectures. |
| PERF01-BP03 | Factor cost into decisions | Cost-benefit analysis for architectural choices exists. Performance at any price is not Well-Architected. |
| PERF01-BP04 | Evaluate customer impact of trade-offs | Quantified impact of performance on business metrics (e.g., latency vs. retention). |
| PERF01-BP05 | Use reference architectures | New workloads follow Service Catalog of approved performance designs. |
| PERF01-BP06 | Benchmark-driven decisions | Benchmark data comparing instance types or DB engines for specific workload exists. |
| PERF01-BP07 | Data-driven architectural choices | Architecture adjusted based on CloudWatch metrics from previous month. |

---

## Compute and Hardware

### PERF 2. How do you select and use compute resources?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| PERF02-BP01 | Best compute options | Selection based on workload needs: Lambda for short tasks, EC2 for long-running. |
| PERF02-BP02 | Understand compute configurations | Can justify why specific instance family was chosen (compute-optimized vs memory-optimized). |
| PERF02-BP03 | Collect compute metrics | CPU, Memory, Disk I/O monitored. Alarms for resource saturation. |
| PERF02-BP04 | Right-size compute | Servers at 10% CPU? Non-compliant, downsize. |
| PERF02-BP05 | Dynamic scaling | Compute units match actual request volume in real-time via Auto Scaling. |
| PERF02-BP06 | Hardware accelerators | GPUs/Trainium/Inferentia for ML. Specialized hardware for tasks inefficient on standard CPUs. |

---

## Data Management

### PERF 3. How do you store, manage, and access data?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| PERF03-BP01 | Purpose-built data stores | NoSQL for key-value, Relational for structured. DB choice matches access pattern. |
| PERF03-BP02 | Evaluate configuration options | Index strategy based on query patterns. DB tuned (IOPS, indexing). |
| PERF03-BP03 | Data store performance metrics | Dashboard showing slowest queries. Query latency and throughput monitored. |
| PERF03-BP04 | Improve query performance | Caching or read replicas offload read traffic from primary DB. |
| PERF03-BP05 | Caching patterns | Same data requested 100 times hits DB 100 times? Non-compliant. Use ElastiCache/CloudFront. |

---

## Networking and Content Delivery

### PERF 4. How do you select and configure networking?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| PERF04-BP01 | Understand networking impact | Networking dependencies mapped. Latency and bandwidth limits accounted for. |
| PERF04-BP02 | Evaluate networking features | Enhanced Networking/ENA enabled on instances. |
| PERF04-BP03 | Dedicated connectivity | Direct Connect for high-bandwidth needs. Hybrid-cloud latency meets business requirements. |
| PERF04-BP04 | Load balancing | ALB or NLB. Traffic spread evenly across healthy targets. |
| PERF04-BP05 | Network protocols | HTTP/2 or gRPC where appropriate. Protocols minimize overhead. |
| PERF04-BP06 | Location-based placement | Compute near users. Multiple regions for global latency reduction. |
| PERF04-BP07 | Metrics-based network optimization | MTU sizes, TCP windows tuned for high-throughput workloads. |

---

## Process and Culture

### PERF 5. How do organizational practices contribute to performance efficiency?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| PERF05-BP01 | Performance KPIs | Performance goals defined, tracked, and reported. |
| PERF05-BP02 | Profiling and monitoring | Can identify specific lines of code causing latency. |
| PERF05-BP03 | Performance improvement process | Performance optimization is regular part of development sprints. |
| PERF05-BP04 | Load testing | Automated load tests in CI/CD pipeline. |
| PERF05-BP05 | Automated performance remediation | System auto-adds resources or clears caches on performance degradation. |
| PERF05-BP06 | Keep workload up-to-date | Runtimes and SDKs updated at least quarterly. |
| PERF05-BP07 | Regular metric reviews | Monthly deep-dive into performance data. |
