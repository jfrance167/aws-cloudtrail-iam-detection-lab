"""Small, offline evaluator for this lab's synthetic detection fixtures.

It intentionally supports only the exact-match subset used by the checked-in
EventBridge patterns. It does not claim to emulate the AWS service.
"""

from __future__ import annotations

import json
from pathlib import Path
from typing import Any


PROJECT_ROOT = Path(__file__).resolve().parents[1]
PATTERN_DIRECTORY = PROJECT_ROOT / "detections" / "event-patterns"
FIXTURE_DIRECTORY = PROJECT_ROOT / "evidence" / "synthetic"

DETECTION_IDS = {
    "root-account-activity": "AWS-CT-001",
    "cloudtrail-configuration-change": "AWS-CT-002",
    "access-key-created": "AWS-CT-003",
    "privileged-policy-attached": "AWS-CT-004",
}


def load_json(path: Path) -> Any:
    """Load UTF-8 JSON from a repository path."""
    with path.open(encoding="utf-8") as handle:
        return json.load(handle)


def eventbridge_subset_matches(pattern: Any, event: Any) -> bool:
    """Evaluate nested objects and arrays of permitted exact values."""
    if isinstance(pattern, dict):
        if not isinstance(event, dict):
            return False
        return all(
            key in event and eventbridge_subset_matches(value, event[key])
            for key, value in pattern.items()
        )

    if isinstance(pattern, list):
        return event in pattern

    return pattern == event


def evaluate_eventbridge_fixture(pattern_name: str, fixture_name: str) -> bool:
    pattern = load_json(PATTERN_DIRECTORY / f"{pattern_name}.json")
    event = load_json(FIXTURE_DIRECTORY / f"{fixture_name}.json")
    return eventbridge_subset_matches(pattern, event)


def count_sandbox_denials(
    events: list[dict[str, Any]], role_name: str, threshold: int = 3
) -> tuple[int, bool]:
    """Count denied events scoped to the exact session-issuer role name."""
    count = 0
    for event in events:
        error_code = str(event.get("errorCode", ""))
        issuer = (
            event.get("userIdentity", {})
            .get("sessionContext", {})
            .get("sessionIssuer", {})
            .get("userName")
        )
        if issuer == role_name and (
            "AccessDenied" in error_code or error_code == "UnauthorizedOperation"
        ):
            count += 1
    return count, count >= threshold


def expected_fixture_results() -> dict[str, bool]:
    """Return the expected positive match for each discrete detection."""
    results = {
        detection_id: evaluate_eventbridge_fixture(name, name)
        for name, detection_id in DETECTION_IDS.items()
    }
    denied_events = load_json(FIXTURE_DIRECTORY / "access-denied-sequence.json")
    _, results["AWS-CT-005"] = count_sandbox_denials(
        denied_events, "aws-detection-lab-sandbox"
    )
    return results

