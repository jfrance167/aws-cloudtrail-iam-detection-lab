# Synthetic Incident Report: Suspicious IAM Activity Sequence

## Document status

- Validation type: **Synthetic only**
- Analyst: `<ANALYST>`
- Scenario date: 2026-01-15
- Detection IDs: AWS-CT-003, AWS-CT-004, AWS-CT-005

## Executive summary

Synthetic evidence represents three denied discovery-like API calls followed by
access-key creation and attachment of a highly privileged managed policy from a
common source. A later synthetic `StopLogging` attempt was denied. The sequence
is suspicious and would justify high-priority investigation, but it is not a
confirmed compromise and did not occur in an AWS account.

## Scope and evidence

- Source: reserved documentation IP `198.51.100.24`
- Principals: `aws-detection-lab-sandbox` and `<ROLE_NAME>`
- Region: `us-east-1` (synthetic label)
- Evidence: JSON fixtures, expected alerts, and synthetic timeline
- Affected identities: `<TARGET_USER>` and `<TARGET_ROLE>`

## Timeline

See `evidence/investigations/sample-timeline.md`. The represented sequence spans
14:02–14:09 UTC.

## Analysis

The first three events resemble IAM discovery but were denied by least
privilege. The later `CreateAccessKey` event represents potential persistence
(T1098.001), and `AttachRolePolicy` represents account manipulation (T1098).
The denied `StopLogging` event resembles attempted cloud-log impairment
(T1562.008). A common source and tight sequence increase concern. However,
because independent synthetic fixtures were joined for training, actor continuity
and intent are assumptions rather than observed facts.

## Severity

**High if real; informational as repository evidence.** Successful credential
creation and administrator-policy attachment would materially increase access.
The represented trail-tampering call failed, reducing but not eliminating risk.

## Containment plan

1. Revoke the suspicious role sessions.
2. Disable only the newly created credential after preserving usage evidence.
3. Remove the unauthorized privileged attachment through an approved responder.
4. Validate trail configuration and S3/CloudWatch delivery.
5. Review all activity for both principals and the source during the scoped window.

## Recovery and lessons learned

Restore least privilege, rotate affected credentials, document the authorized
baseline, and add semantic review for custom privilege-escalation policies. Keep
the denied-call threshold role-scoped to reduce noise.

## Limitations

No AWS resources, alerts, queries, or response actions were used. Timestamps,
identities, event outcomes, and source address are synthetic.

