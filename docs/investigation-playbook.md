# Investigation Playbook

## Trigger

Use this playbook for any lab alert in the detection catalog. Treat an alert as
a lead, not confirmation of compromise.

## Triage

1. Record detection ID, event time, event name, Region, and alert source.
2. Identify `userIdentity.type`, principal ARN, session issuer, and MFA state.
3. Replace the source IP with a reserved address before publishing evidence.
4. Determine success or failure from `errorCode` and `errorMessage`.
5. Confirm the affected resource and request parameters.
6. Compare with approved lab activity and maintenance windows.

## Scope

Run the Athena queries for the principal, source IP, denied calls, IAM changes,
access-key changes, trail changes, and complete timeline. Pivot at least 15
minutes before and after the alert. Look for a second principal or source,
credential use after creation, and changes that could suppress logging.

## Assess

Classify the event as expected, benign but unauthorized, suspicious, or
confirmed malicious only when evidence supports that conclusion. Consider
privilege, persistence, defense evasion, successful actions, and blast radius.

## Contain

For a real event, follow organizational authorization and preserve logging.
Potential actions include revoking the role session, disabling a specific
credential, reverting an unauthorized policy attachment, and restricting the
principal. Never delete the trail or evidence while investigating.

## Recover and improve

Restore intended IAM state, rotate only affected credentials, validate logging,
review adjacent activity, tune noisy detections, and record lessons learned.
Use the incident report template and update `VALIDATION.md` honestly.

