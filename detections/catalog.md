# Detection Catalog

Every rule is an alerting lead. MITRE ATT&CK mappings describe behavior that
could be relevant; they do not establish malicious intent.

## AWS-CT-001 — Root-account activity

- **Purpose:** Surface use of the account root identity, which should be rare.
- **Event source:** CloudTrail events from AWS Sign-In, IAM, or STS.
- **Fields:** `detail.userIdentity.type`, `detail.eventName`, `detail.sourceIPAddress`.
- **Logic:** Match an AWS API or console sign-in event whose identity type is `Root`.
- **MITRE ATT&CK:** T1078.004, Valid Accounts: Cloud Accounts.
- **Alert:** Detection ID/name, event time/name, principal type, Region, and source.
- **Investigation:** Verify break-glass authorization and MFA; pivot on the source
  and adjacent root events; inspect billing, IAM, and trail changes.
- **False positives:** Authorized account recovery or billing task.
- **Tuning:** Do not suppress root events; enrich with approved maintenance data.
- **Containment:** End unauthorized sessions, secure root credentials, verify MFA,
  remove root access keys if present, and preserve logs.
- **Validation:** Synthetic fixture only. Never sign in as root for this lab.

## AWS-CT-002 — CloudTrail configuration change

- **Purpose:** Detect attempted logging impairment or configuration drift.
- **Event source:** `cloudtrail.amazonaws.com` management events.
- **Event names:** `StopLogging`, `DeleteTrail`, `UpdateTrail`,
  `PutEventSelectors`, `PutInsightSelectors`, `DeleteEventDataStore`,
  `UpdateEventDataStore`.
- **Logic:** Match any listed API call, successful or denied.
- **MITRE ATT&CK:** T1562.008, Impair Defenses: Disable or Modify Cloud Logs.
- **Alert:** Actor/session, API, error, source, Region, and request parameters.
- **Investigation:** Determine success, compare configuration, inspect caller
  privilege changes, and confirm S3 delivery continuity.
- **False positives:** Approved logging maintenance or Terraform deployment.
- **Tuning:** Correlate with approved change windows; never suppress successful
  stop or delete operations.
- **Containment:** Revoke unauthorized session, restore the approved trail, and
  investigate the period of reduced visibility.
- **Validation:** Synthetic fixture only. Do not modify the real trail.

## AWS-CT-003 — IAM access-key creation

- **Purpose:** Detect creation of a new long-term IAM credential.
- **Event source:** `iam.amazonaws.com`.
- **Event name:** `CreateAccessKey`.
- **Fields:** Actor, `requestParameters.userName`, target resources, error fields.
- **Logic:** Match every creation attempt, including denied attempts.
- **MITRE ATT&CK:** T1098.001, Account Manipulation: Additional Cloud Credentials.
- **Alert:** Actor, target identity, success/failure, time, source, and Region.
- **Investigation:** Determine who requested the key, whether it succeeded, and
  whether the new key was subsequently used from a new source.
- **False positives:** Approved credential rotation for a legacy integration.
- **Tuning:** Enrich with ticket/owner data; do not include the key ID in public evidence.
- **Containment:** Disable the specific unauthorized key, preserve usage history,
  and rotate affected credentials according to policy.
- **Validation:** Synthetic fixture only; creating a real key is unnecessary.

## AWS-CT-004 — Privileged managed policy attachment

- **Purpose:** Detect direct attachment of selected AWS-managed high-privilege policies.
- **Event source:** `iam.amazonaws.com`.
- **Event names:** `AttachUserPolicy`, `AttachRolePolicy`, `AttachGroupPolicy`.
- **Fields:** Actor, target identity, `requestParameters.policyArn`, error fields.
- **Logic:** Match policy ARNs for `AdministratorAccess`, `IAMFullAccess`, or
  `PowerUserAccess`.
- **MITRE ATT&CK:** T1098, Account Manipulation.
- **Alert:** Actor, target, policy label, success/failure, source, and time.
- **Investigation:** Determine success, target sessions, related policy changes,
  and whether the actor used the new privilege.
- **False positives:** Approved administrative provisioning.
- **Tuning:** Extend the allow-list for organization-specific privileged policies;
  add separate semantic analysis for custom inline policies.
- **Containment:** Detach an unauthorized policy through an approved responder,
  revoke affected sessions, and restore least privilege.
- **Validation:** Synthetic fixture only. Never attach these policies for testing.

## AWS-CT-005 — Repeated denied sandbox-role calls

- **Purpose:** Surface possible reconnaissance or misuse by the restricted role.
- **Event source:** CloudTrail delivered to CloudWatch Logs.
- **Fields:** `errorCode`, session issuer user name, event name, source, and time.
- **Logic:** Metric filter counts `AccessDenied*` or `UnauthorizedOperation` for
  the exact sandbox role; alarm at three events in one five-minute period.
- **MITRE ATT&CK:** T1087.004, Account Discovery: Cloud Account, when the denied
  APIs are discovery-oriented. Mapping is contextual, not universal.
- **Alert:** Threshold, period, alarm time, metric, and runbook link.
- **Investigation:** Query the underlying events to recover API names, principal,
  source, errors, and adjacent successful actions.
- **False positives:** Mistyped commands, missing permission, or training activity.
- **Tuning:** Adjust threshold only after reviewing event volume; keep role scope.
- **Containment:** Revoke the role session if activity is unauthorized; do not
  expand permissions to eliminate the alert.
- **Validation:** Synthetic sequence locally; harmless denied live calls planned.

