# Safe Activity Generation

These commands are a plan, not a record of execution. Run them only after an
approved deployment, while authenticated to the dedicated sandbox account.

## Preconditions

- Confirm the private account and selected Region outside the repository.
- Confirm the trail is logging and the role name matches the reviewed plan.
- Assume the sandbox role through an MFA-protected trusted principal.
- Keep credentials and returned identifiers out of screenshots and shell logs.

## Permitted activity

Once the temporary role session is active, use read-only calls:

```powershell
aws sts get-caller-identity
aws iam get-role --role-name <SANDBOX_ROLE_NAME>
aws cloudtrail lookup-events --max-results 5
```

The identity response contains an account ID and ARN. Do not copy it into this
repository.

## Repeated-denial scenario

Within five minutes, attempt the following exactly three times. It should fail
because `iam:ListUsers` is not allowed:

```powershell
aws iam list-users
```

Do not broaden the role if it fails as intended. Wait for CloudTrail and the
alarm rather than generating additional traffic. Record only a sanitized alert.

## Synthetic-only scenarios

Use the fixtures under `evidence/synthetic/` for root activity, trail changes,
access-key creation, and privileged policy attachment. Never reproduce those
events in the deployed account just to demonstrate a detection.

