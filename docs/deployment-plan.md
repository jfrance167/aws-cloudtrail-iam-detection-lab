# Gated AWS Deployment Plan

No commands in this document have been executed. Deployment requires a separate
approval after review of an actual `terraform plan`.

## Planned resources

- 1 customer-managed KMS key and alias
- 2 private S3 buckets: CloudTrail archive and Athena results
- 1 multi-Region CloudTrail trail
- 1 CloudWatch log group, delivery role/policy, metric filter, and alarm
- 4 EventBridge rules and 4 SNS targets
- 1 encrypted SNS topic and optional email subscription
- 1 restricted IAM sandbox role with managed inline policy
- 1 Glue database and projected CloudTrail table
- 1 Athena workgroup with 100 MiB scan cutoff
- 1 monthly AWS Budget with three SNS thresholds

## Inputs requiring private review

- `aws_region`
- `sandbox_trusted_principal_arn`
- optional `alert_email` supplied through `TF_VAR_alert_email`, never committed
- retention, budget, and deletion-window values

## Proposed commands

```powershell
terraform -chdir=terraform/environments/lab init
terraform -chdir=terraform/environments/lab plan -out=lab.tfplan
terraform -chdir=terraform/environments/lab show lab.tfplan
```

Planning can reveal account-specific values, so its output is private. After
the exact plan, cost, target identity, and rollback are reviewed, a separately
approved deployment would use:

```powershell
terraform -chdir=terraform/environments/lab apply lab.tfplan
```

## Rollback

Stop safe activity, preserve sanitized evidence, review a destroy plan, empty
only the verified lab buckets, apply the approved destroy plan, and confirm KMS
deletion scheduling and billing. See `TEARDOWN.md`.

