# Synthetic Incident Timeline

> This timeline is entirely synthetic. It is not evidence of an AWS compromise.

| Time (UTC) | Principal | Source | Event | Result | Interpretation |
| --- | --- | --- | --- | --- | --- |
| 14:02 | `aws-detection-lab-sandbox` | `198.51.100.24` | `ListUsers` | Denied | Possible account discovery or operator mistake |
| 14:03 | Same | Same | `ListRoles` | Denied | Repeated discovery-like behavior |
| 14:04 | Same | Same | `GetAccountAuthorizationDetails` | Denied | Threshold for AWS-CT-005 reached |
| 14:07 | `<ROLE_NAME>` | Same | `CreateAccessKey` | Synthetic success | Persistence-like credential event represented by fixture |
| 14:08 | Same | Same | `AttachRolePolicy` | Synthetic success | `AdministratorAccess` attachment represented by fixture |
| 14:09 | Same | Same | `StopLogging` | Synthetic denied | Attempted defense-evasion behavior represented by fixture |

The common source and close timing support treating the events as one scenario,
but the fixtures alone do not prove malicious intent or a real compromise.

