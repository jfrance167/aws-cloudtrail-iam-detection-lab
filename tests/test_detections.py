import json
import sys
import unittest
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT_ROOT / "scripts"))

from detection_engine import (  # noqa: E402
    FIXTURE_DIRECTORY,
    count_sandbox_denials,
    evaluate_eventbridge_fixture,
    eventbridge_subset_matches,
    expected_fixture_results,
    load_json,
)


class DetectionTests(unittest.TestCase):
    def test_all_expected_fixtures_match(self) -> None:
        self.assertEqual(
            expected_fixture_results(),
            {
                "AWS-CT-001": True,
                "AWS-CT-002": True,
                "AWS-CT-003": True,
                "AWS-CT-004": True,
                "AWS-CT-005": True,
            },
        )

    def test_benign_event_does_not_match_root(self) -> None:
        event = load_json(FIXTURE_DIRECTORY / "root-account-activity.json")
        event["detail"]["userIdentity"]["type"] = "AssumedRole"
        pattern = load_json(
            PROJECT_ROOT / "detections/event-patterns/root-account-activity.json"
        )
        self.assertFalse(eventbridge_subset_matches(pattern, event))

    def test_unlisted_policy_does_not_match_privileged_rule(self) -> None:
        event = load_json(FIXTURE_DIRECTORY / "privileged-policy-attached.json")
        event["detail"]["requestParameters"]["policyArn"] = (
            "arn:aws:iam::aws:policy/ReadOnlyAccess"
        )
        pattern = load_json(
            PROJECT_ROOT
            / "detections/event-patterns/privileged-policy-attached.json"
        )
        self.assertFalse(eventbridge_subset_matches(pattern, event))

    def test_denial_threshold_is_role_scoped(self) -> None:
        events = load_json(FIXTURE_DIRECTORY / "access-denied-sequence.json")
        count, triggered = count_sandbox_denials(
            events, "aws-detection-lab-sandbox"
        )
        self.assertEqual(count, 3)
        self.assertTrue(triggered)
        other_count, other_triggered = count_sandbox_denials(events, "another-role")
        self.assertEqual(other_count, 0)
        self.assertFalse(other_triggered)

    def test_fixture_json_is_valid(self) -> None:
        for path in FIXTURE_DIRECTORY.glob("*.json"):
            with self.subTest(path=path.name):
                json.loads(path.read_text(encoding="utf-8"))


if __name__ == "__main__":
    unittest.main()

