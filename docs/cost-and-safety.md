# Cost and Safety Guide

## Expected cost profile

The quiet-lab target is approximately `$1–$3/month`. This is an estimate, not a
guarantee, and must be recalculated for the selected Region before deployment.

| Service | Cost control |
| --- | --- |
| CloudTrail | One copy of management events; data events and Insights disabled |
| KMS | One customer-managed key; delete the lab when finished |
| S3 | Small log volume, lifecycle expiration, no replication |
| CloudWatch Logs | 14-day default retention |
| EventBridge | AWS management events only; no archive or replay |
| SNS | Standard topic and email; no SMS |
| Athena | Partition projection and 100 MiB per-query cutoff |
| Glue | One external table; no crawler |
| Budgets | `$5` monthly budget routed to SNS |

The KMS key is the main predictable fixed charge. S3, CloudWatch, SNS, and
Athena are usage-based. CloudTrail-to-CloudWatch delivery can carry a separate
per-GB charge. Budget data is delayed and does not stop services.

## Before deployment

1. Use a dedicated sandbox account with MFA on the root user and no root access
   keys.
2. Confirm the selected Region and current AWS pricing.
3. Confirm there is not already a billable second trail copy.
4. Review `terraform plan` for exactly the resources in `deployment-plan.md`.
5. Set the budget below the maximum amount you are willing to spend.
6. Confirm the notification endpoint without placing its address in Git.

## Prohibited validation actions

- Do not log in as root merely to generate an alert.
- Do not call `StopLogging`, `DeleteTrail`, or mutate the deployed trail.
- Do not attach `AdministratorAccess`, `IAMFullAccess`, or `PowerUserAccess`.
- Do not create a real access key for validation.
- Do not run the role or Terraform against a production account.
- Do not enable high-volume data events merely to produce evidence.

## Operational cautions

CloudTrail and alert delivery are asynchronous. Wait for normal service
delivery rather than repeating calls rapidly. Stop testing if identity, Region,
or cost information differs from the reviewed plan.

