# Security Policy

## Scope and intended use

This is an educational sandbox, not a production reference architecture. Use it
only in a dedicated AWS account where you have explicit authorization.

## Never commit

- AWS access keys, session tokens, passwords, or credential files
- Real account IDs, ARNs, usernames, email addresses, bucket names, or org IDs
- Public IP addresses associated with a person or organization
- Unsanitized CloudTrail, Athena, CloudWatch, or SNS output
- Terraform state, plans, crash logs, `.env` files, private keys, or console URLs

Use `<ACCOUNT_ID>`, `<ROLE_NAME>`, `<BUCKET_NAME>`, and reserved documentation
networks such as `192.0.2.0/24`, `198.51.100.0/24`, and `203.0.113.0/24`.

## Credential handling

The repository and CI require no AWS credentials. For an approved deployment,
authenticate outside the repository with an established AWS CLI profile or
short-lived identity-center session. Do not paste credentials into prompts,
commands, Terraform variables, issue descriptions, or evidence.

## Reporting

Report leaked data or unsafe automation privately. Revoke or rotate exposed
credentials before attempting repository-history cleanup. Do not open a public
issue containing the exposed value.

## Publishing checklist

1. Run the unit and repository-safety tests.
2. Run Checkov and the SAST workflow.
3. Inspect every evidence artifact using `docs/sanitization-guide.md`.
4. Confirm `VALIDATION.md` accurately distinguishes real and synthetic work.
5. Review document metadata and image backgrounds for identifiers.

