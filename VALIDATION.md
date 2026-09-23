# Validation Record

This file is the source of truth for validation status. A checked item means the
named validation was actually completed; prose elsewhere must not override it.

## Completed local validation

- [x] Python unit tests pass (13 tests).
- [x] Synthetic fixture evaluator reports all expected detections.
- [x] Repository safety tests find no prohibited credential material.
- [x] `terraform fmt -check -recursive` passes.
- [x] `terraform init -backend=false` completes.
- [x] `terraform validate` passes with Terraform 1.13.3 and AWS provider 5.100.0.
- [x] Checkov 3.3.19 reports 145 passed, 11 documented exceptions, and 0 failed checks.
- [x] Bandit 1.9.4 reports zero findings across `scripts/` and `tests/`.
- [x] All workflow YAML parses and receives a manual minimum-permission review.
- [x] CodeQL SAST completes in GitHub Actions.

## Completed GitHub validation

- [x] CI passes on the default branch (unit, synthetic detection, Terraform, and Checkov jobs).
- [x] Bandit passes on the default branch with zero findings.
- [x] CodeQL analysis passes on the default branch.
- [x] GitHub's code-scanning queue reports zero open alerts.
- [x] GitHub Actions are pinned to immutable commit SHAs and use minimum permissions.

## Completed AWS validation

- [ ] Terraform plan reviewed against the approved resource inventory.
- [ ] AWS resources deployed in a dedicated sandbox account.
- [ ] CloudTrail delivers management events to S3 and CloudWatch Logs.
- [ ] Harmless authorized sandbox activity appears in CloudTrail.
- [ ] Repeated denied calls trigger AWS-CT-005.
- [ ] SNS notification delivery is confirmed.
- [ ] Athena queries return sanitized expected results.
- [ ] AWS resources are torn down and cost monitoring is checked.

No AWS validation has been completed.

## Completed synthetic validation

- [x] AWS-CT-001 root-account fixture matches its EventBridge pattern.
- [x] AWS-CT-002 CloudTrail-change fixture matches its EventBridge pattern.
- [x] AWS-CT-003 access-key fixture matches its EventBridge pattern.
- [x] AWS-CT-004 privileged-policy fixture matches its EventBridge pattern.
- [x] AWS-CT-005 denied-call sequence crosses its local threshold.
- [x] Synthetic incident timeline and report are internally consistent.

## Planned but incomplete

- An approved AWS `terraform plan` using a sanitized variable file.
- Live deployment and harmless restricted-role validation.
- Captured and sanitized Terraform, Checkov, alert, and Athena evidence.

## Known limitations

- Local matching validates repository logic, not AWS service delivery.
- Terraform validation cannot verify account quotas, service-linked settings,
  email confirmation, or runtime IAM/KMS interactions.
- Budget notifications may be delayed and cannot prevent spend.
- Synthetic events intentionally omit or replace sensitive fields.
