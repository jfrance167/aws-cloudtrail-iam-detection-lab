# Validation Record

This file is the source of truth for validation status. A checked item means the
named validation was actually completed; prose elsewhere must not override it.

## Completed local validation

- [ ] Python unit tests pass.
- [ ] Synthetic fixture evaluator reports all expected detections.
- [ ] Repository safety tests find no prohibited credential material.
- [ ] `terraform fmt -check -recursive` passes.
- [ ] `terraform init -backend=false` completes.
- [ ] `terraform validate` passes.
- [ ] Checkov completes with no unsuppressed HIGH or CRITICAL findings.
- [ ] GitHub workflow YAML receives a manual safety review.
- [ ] CodeQL SAST completes in GitHub Actions.

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

- [ ] AWS-CT-001 root-account fixture matches its EventBridge pattern.
- [ ] AWS-CT-002 CloudTrail-change fixture matches its EventBridge pattern.
- [ ] AWS-CT-003 access-key fixture matches its EventBridge pattern.
- [ ] AWS-CT-004 privileged-policy fixture matches its EventBridge pattern.
- [ ] AWS-CT-005 denied-call sequence crosses its local threshold.
- [ ] Synthetic incident timeline and report are internally consistent.

## Planned but incomplete

- An approved AWS `terraform plan` using a sanitized variable file.
- Live deployment and harmless restricted-role validation.
- Captured and sanitized Terraform, Checkov, alert, and Athena evidence.
- SAST execution in GitHub Actions after explicit GitHub-change approval.

## Known limitations

- Local matching validates repository logic, not AWS service delivery.
- Terraform validation cannot verify account quotas, service-linked settings,
  email confirmation, or runtime IAM/KMS interactions.
- Budget notifications may be delayed and cannot prevent spend.
- Synthetic events intentionally omit or replace sensitive fields.

