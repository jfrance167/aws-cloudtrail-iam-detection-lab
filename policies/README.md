# Policy Examples

`sandbox-role-policy.json` is a sanitized, human-readable summary of the role's
security intent. Terraform is authoritative and adds the archive location plus
additional explicit denies. The wildcard on `cloudtrail:LookupEvents` is
required because that API does not support resource-level authorization. The
wildcard resources in explicit deny statements do not grant access.

