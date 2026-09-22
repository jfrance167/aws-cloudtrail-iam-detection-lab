# Athena Investigation Queries

Replace `<ATHENA_DATABASE>`, `<CLOUDTRAIL_TABLE>`, date partitions, and other
angle-bracket placeholders in a private working copy. Keep partition predicates
to control scan cost. Run only through the lab workgroup, which enforces a 100
MiB per-query cutoff. Do not publish raw results.

CloudTrail fields such as `requestparameters` are stored as JSON strings in the
lab table, so queries use `json_extract_scalar` for selected values.

