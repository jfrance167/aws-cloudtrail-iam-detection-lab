# Teardown Guide

Teardown is destructive and requires explicit approval. Preserve only sanitized
evidence before proceeding.

## Pre-teardown checks

1. Confirm the target account and Region using non-secret identifiers.
2. Export and sanitize required evidence; never copy raw logs into Git.
3. Confirm no investigation or retention obligation requires the logs.
4. Review the Terraform plan for destroy before approving it.

## Planned sequence

```powershell
terraform -chdir=terraform/environments/lab plan -destroy -out=destroy.tfplan
terraform -chdir=terraform/environments/lab show destroy.tfplan
```

Because `force_destroy` defaults to `false`, first empty only the two exact
lab-created buckets after verifying their names and account. Do not use a broad
wildcard or a recursive command against an unresolved variable. Then, after a
second review:

```powershell
terraform -chdir=terraform/environments/lab apply destroy.tfplan
```

The KMS key is scheduled for deletion rather than immediately erased. Confirm
the configured waiting period. Delete local `*.tfplan` files after review; they
may contain sensitive infrastructure values.

## Confirmation record

Record the following in private notes, then publish only sanitized status:

- Destroy plan review date
- Exact account and Region verified privately
- S3 log archive emptied intentionally
- Athena result bucket emptied intentionally
- Trail, rules, alarms, topic, role, table, workgroup, and budget removed
- KMS key scheduled for deletion
- Final billing dashboard reviewed after billing data settled
- Public `VALIDATION.md` updated without identifiers

No teardown has been performed for this repository.

