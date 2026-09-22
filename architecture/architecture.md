# Architecture and Threat Model

## Objective

Capture authorized control-plane activity from a dedicated sandbox role,
preserve it in an encrypted archive, detect selected IAM and logging risks, and
support a reproducible investigation without performing unsafe actions.

## Data flow

1. An authorized operator assumes the restricted sandbox role using MFA.
2. AWS APIs emit management events to a multi-Region CloudTrail trail.
3. CloudTrail writes validated log files to a private KMS-encrypted S3 bucket
   and streams events to an encrypted CloudWatch Logs group.
4. EventBridge matches discrete high-risk API events and sends them to SNS.
5. A CloudWatch metric filter counts denied sandbox-role calls; an alarm sends
   a notification when three events occur within five minutes.
6. A Glue external table makes the S3 archive queryable from a constrained
   Athena workgroup. Results go to a separate encrypted private bucket.
7. An AWS Budget sends threshold notifications to the same SNS topic.

The Mermaid source is maintained in [architecture.mmd](architecture.mmd).

## Trust boundaries

| Boundary | Assets crossing it | Control |
| --- | --- | --- |
| Operator to AWS STS | Role session | Explicit trusted principal, MFA requirement, short session |
| CloudTrail to S3 | Audit logs | Service-principal policy, source ARN/account conditions, TLS, KMS |
| CloudTrail to Logs | Event stream | Dedicated least-privilege delivery role |
| Event services to SNS | Alert payload | Topic policy limited to EventBridge, CloudWatch, and Budgets |
| Analyst to Athena | Logs and results | Workgroup enforcement, encryption, scan cutoff, IAM outside module |
| Local repository | Synthetic evidence | Placeholders, reserved IPs, repository-safety tests |

## Security decisions

- The trail captures read and write management events but no data events. This
  covers the target IAM and CloudTrail APIs while avoiding noisy paid telemetry.
- `force_destroy` is false. Evidence must be deliberately emptied before
  teardown, reducing accidental loss.
- S3 versioning and CloudTrail log-file validation help identify overwrite or
  deletion attempts; this is not immutable WORM storage.
- A single customer-managed KMS key keeps the demonstration understandable and
  limits fixed cost. Production designs may separate keys by service and duty.
- The Athena table uses partition projection instead of a crawler, reducing
  background cost and infrastructure.
- The sandbox role has an explicit deny for access-key, policy-attachment, and
  trail-tampering actions in addition to a narrow allow-list.

## Threats considered

| Threat | Mitigation | Residual risk |
| --- | --- | --- |
| Root use bypasses normal federation | Immediate alert and root-specific playbook | Notification latency |
| Adversary modifies audit configuration | Detect change APIs; archive validation | Detection cannot prevent a fully privileged actor |
| New long-term credential created | Detect `CreateAccessKey` | Existing or service-specific credentials need other controls |
| Privilege added via managed policy | High-risk policy allow-list | Custom inline policy escalation is not semantically analyzed |
| Reconnaissance creates denied calls | Threshold scoped to sandbox role | Legitimate mistakes can trigger it |
| Public or unencrypted evidence | S3 controls, KMS, TLS-only policies | Analysts can still mishandle downloaded data |
| CI supply-chain compromise | SHA-pinned actions, minimal permissions, no AWS secrets | Upstream action compromise before pinned revision remains possible |

## Production extensions

Use an organization trail, delegated security account, SCPs, immutable log
archive, cross-account alerting, centralized SIEM, automated response with
approval controls, and separate KMS administration. These are intentionally
outside this low-cost single-account lab.

