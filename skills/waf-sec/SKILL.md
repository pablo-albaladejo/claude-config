---
name: waf-sec
description: Well-Architected Security pillar - SEC 1-11, identity, detection, infrastructure/data protection, incident response, app security
triggers:
  - security pillar
  - defense in depth
  - IAM review
  - data protection
  - incident response
  - application security
---

# WAF Pillar: Security (SEC)

Protect information, systems, and assets through risk assessment and mitigation. Multi-layered "Defense in Depth."

## Design Principles

- Implement a strong identity foundation
- Enable traceability
- Apply security at all layers
- Automate security best practices
- Protect data in transit and at rest
- Keep people away from data
- Prepare for security events

---

## Security Foundations

### SEC 1. How do you securely operate your workload?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| SEC01-BP01 | Separate workloads using accounts | Production data never resides in the same account as development code. |
| SEC01-BP02 | Secure root user | MFA enabled, no active access keys. Root email is protected distribution list. Password in vault. |
| SEC01-BP03 | Identify and validate control objectives | Security requirements documented as part of application design phase. |
| SEC01-BP04 | Stay up to date with threats | Organization acted on a recent AWS Security Advisory within defined SLA. |
| SEC01-BP05 | Reduce security management scope | Managed services (RDS, etc.) used to shift security burden to AWS. |
| SEC01-BP06 | Automate standard security controls | Every new account auto-gets GuardDuty, CloudTrail, Config via central template. |
| SEC01-BP07 | Threat model | Document maps specific threats to technical controls (e.g., STRIDE). |
| SEC01-BP08 | Evaluate new security services regularly | Security team reviews AWS "What's New" monthly for new protection mechanisms. |

---

## Identity and Access Management

### SEC 2. How do you manage authentication?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| SEC02-BP01 | Strong sign-in mechanisms | Login without MFA is technically impossible across the entire organization. |
| SEC02-BP02 | Temporary credentials | No long-lived IAM user keys. IAM Roles + Federation for short-lived tokens. |
| SEC02-BP03 | Secrets stored securely | Secrets never hardcoded. Auto-rotated via Secrets Manager or Parameter Store. |
| SEC02-BP04 | Centralized identity provider | Human access disabled centrally when employee leaves (AD, Okta, IAM Identity Center). |
| SEC02-BP05 | Audit and rotate credentials | Automated report of all active roles and usage patterns. |
| SEC02-BP06 | User groups and attributes | Permissions assigned to IAM Groups or via ABAC, not individual users. |

### SEC 3. How do you manage permissions?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| SEC03-BP01 | Define access requirements | Clear "Least Privilege" policy for every application component. |
| SEC03-BP02 | Least privilege access | No developer has "AdministratorAccess" except emergency tasks. |
| SEC03-BP03 | Emergency access process | Documented, tested "Break Glass" procedure with audit trail. |
| SEC03-BP04 | Reduce permissions continuously | IAM Access Analyzer used. Unused permissions regularly removed based on usage data. |
| SEC03-BP05 | Permission guardrails | SCPs block high-risk actions (e.g., deleting S3 buckets) org-wide regardless of IAM. |
| SEC03-BP06 | Lifecycle-based access | Access auto-provisioned on hire, auto-revoked on termination. |
| SEC03-BP07 | Analyze public/cross-account access | Daily report of all S3 buckets or IAM roles with public or external access. |
| SEC03-BP08 | Share resources securely internally | AWS RAM for VPC subnets/license configs. No broad IAM permissions. |
| SEC03-BP09 | Share resources securely with third parties | IAM Roles with External IDs. Never share access keys with vendors. |

---

## Detection

### SEC 4. How do you detect and investigate security events?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| SEC04-BP01 | Service and application logging | CloudTrail, VPC Flow Logs, DNS logs enabled. Every API call and network flow recorded. |
| SEC04-BP02 | Centralized log capture | Logs in dedicated Security account. Can a compromised workload admin delete them? If no, compliant. |
| SEC04-BP03 | Correlate and enrich alerts | GuardDuty + Security Hub. Alerts grouped by severity with context (IP reputation). |
| SEC04-BP04 | Auto-remediate non-compliant resources | S3 bucket made public is auto-reverted within seconds by Lambda. |

---

## Infrastructure Protection

### SEC 5. How do you protect network resources?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| SEC05-BP01 | Network layers | VPC subnets isolate components (Public, Private, Data). Database has no internet path. |
| SEC05-BP02 | Control traffic flow | Security Groups + NACLs. Only required ports/protocols open. |
| SEC05-BP03 | Inspection-based protection | AWS WAF for web, Network Firewall for VPC. SQL injection filtered. |
| SEC05-BP04 | Automate network protection | Firewall Manager deploys consistent rules. New VPCs auto-get standard security group rules. |

### SEC 6. How do you protect compute resources?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| SEC06-BP01 | Vulnerability management | Amazon Inspector scans for CVEs. Defined SLA for patching Critical/High. |
| SEC06-BP02 | Hardened images | AMI bakery with security-approved list. All instances from approved AMIs. |
| SEC06-BP03 | Reduce interactive access | SSH/RDP disabled. Systems Manager Session Manager only. No SSH key used in 30 days. |
| SEC06-BP04 | Validate software integrity | Code signing and checksums. Only verified software runs. |
| SEC06-BP05 | Automate compute protection | Systems Manager automates security agent installation. No unmanaged servers. |

---

## Data Protection

### SEC 7. How do you classify data?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| SEC07-BP01 | Data classification scheme | Levels defined (Public, Internal, Confidential). Every data store tagged with classification. |
| SEC07-BP02 | Controls match sensitivity | Confidential data gets encryption + strict logging matching classification policy. |
| SEC07-BP03 | Automated identification | Amazon Macie scans for PII. Alert on sensitive data in unencrypted buckets. |
| SEC07-BP04 | Data lifecycle management | S3 lifecycle policies auto-delete/archive per retention requirements. |

### SEC 8. How do you protect data at rest?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| SEC08-BP01 | Secure key management | AWS KMS. Keys managed separately from the data they protect. |
| SEC08-BP02 | Enforce encryption at rest | IAM policy or SCP prevents creation of unencrypted EBS volumes or S3 buckets. |
| SEC08-BP03 | Automate data-at-rest protection | Automated detection and remediation of unencrypted storage. |
| SEC08-BP04 | Enforce access control | S3 Bucket + KMS Key Policies. Access limited to specific app role, not "authenticated users." |

### SEC 9. How do you protect data in transit?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| SEC09-BP01 | Key and certificate management | ACM with auto-renewal, centrally managed. |
| SEC09-BP02 | Enforce encryption in transit | TLS 1.2+ for all communication. No unencrypted HTTP traffic. |
| SEC09-BP03 | Authenticate network communications | mTLS or SigV4 for service-to-service. Every connection requires valid identity. |

---

## Incident Response

### SEC 10. How do you respond to and recover from incidents?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| SEC10-BP01 | Key personnel identified | Contact list for legal, security, AWS support. Audited quarterly. |
| SEC10-BP02 | Incident management plans | SIRP covers cloud scenarios ("Compromised Access Key"). |
| SEC10-BP03 | Forensic capabilities | Can isolate instance and take snapshot. Can capture memory dump without stopping instance. |
| SEC10-BP04 | Tested playbooks | Step-by-step guides for common security events. Used during simulations. |
| SEC10-BP05 | Pre-provisioned access | IR team has "Security Auditor" role ready before events. |
| SEC10-BP06 | Pre-deployed tools | Security account has log analysis and forensic infrastructure ready. |
| SEC10-BP07 | Run simulations | Purple Team exercises performed. Results and lessons documented. |
| SEC10-BP08 | Learning framework | IR plan revised based on Post-Mortem findings after every event. |

---

## Application Security

### SEC 11. How do you validate security throughout the lifecycle?

| BP | Practice | Litmus Test |
|----|----------|-------------|
| SEC11-BP01 | Application security training | Developers trained on OWASP Top 10. Regular, documented sessions. |
| SEC11-BP02 | Automated security testing | SAST + DAST in CI/CD. Vulnerabilities must break the build. |
| SEC11-BP03 | Regular penetration testing | External pen test on production within last year. |
| SEC11-BP04 | Security-focused code reviews | "Security Approval" is mandatory PR step. |
| SEC11-BP05 | Centralized package services | CodeArtifact or equivalent. Only curated, security-vetted libraries. |
| SEC11-BP06 | Programmatic deployment | IaC only. No manual "click-ops" in production. |
| SEC11-BP07 | Pipeline security assessment | CI/CD environment audited for least privilege and logging. |
| SEC11-BP08 | Security ownership in teams | "Security Champions" designated per product team. |
