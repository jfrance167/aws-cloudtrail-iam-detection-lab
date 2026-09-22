# Evidence Sanitization Guide

Sanitize a copy; never edit the only source of incident evidence. Raw material
belongs in an ignored private location and must not be committed.

## Required replacements

| Sensitive value | Public replacement |
| --- | --- |
| AWS account ID | `<ACCOUNT_ID>` |
| Full ARN | `arn:aws:iam::<ACCOUNT_ID>:role/<ROLE_NAME>` or equivalent |
| User name or email | `<ANALYST>` or `<USER_NAME>` |
| Public source IP | `198.51.100.24`, `192.0.2.10`, or `203.0.113.8` |
| Bucket name | `<CLOUDTRAIL_BUCKET>` or `<ATHENA_RESULTS_BUCKET>` |
| Organization ID | `<ORGANIZATION_ID>` |
| Access-key ID | `<ACCESS_KEY_ID>` |
| Session name/ID | `<SESSION_NAME>` / `<SESSION_ID>` |
| Request parameter | Keep only fields required to explain the detection |
| Internal convention | Replace with a functional placeholder |

## CloudTrail-specific review

Inspect `userIdentity`, `sessionContext`, `requestParameters`,
`responseElements`, `resources`, `recipientAccountId`, `sharedEventID`,
`sourceIPAddress`, `userAgent`, and every ARN. Secrets normally should not
appear in CloudTrail, but do not assume a field is safe merely because it is a
service log.

## Images and documents

Crop browser chrome, account menus, tabs, notifications, and desktop paths.
Check document metadata and hidden layers. Redaction must remove underlying
data rather than cover it with a translucent shape.

## Final verification

Run the repository-safety tests, search for 12-digit numbers, `AKIA`/`ASIA`
patterns, `arn:aws`, email addresses, and non-reserved IPv4 addresses. Manually
review context because automated patterns have false positives and blind spots.

