# Evidence Index

Only synthetic evidence is present. No files in this directory were produced by
an AWS deployment.

| Artifact | Type | Status |
| --- | --- | --- |
| `synthetic/*.json` | Sanitized CloudTrail/EventBridge fixtures | Synthetic |
| `alerts/sample-alerts.json` | Expected alert examples | Synthetic |
| `investigations/sample-timeline.md` | Analyst timeline | Synthetic |
| `../reports/sanitized-sample-incident-report.md` | Incident report | Synthetic |

Reserved directories `evidence/private/` and `evidence/raw/` are gitignored.
Before publishing future evidence, follow `docs/sanitization-guide.md` and
update `VALIDATION.md` with exactly what was observed.

