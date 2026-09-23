import re
import unittest
from pathlib import Path


REPOSITORY_ROOT = Path(__file__).resolve().parents[1]
WORKFLOW_DIRECTORY = REPOSITORY_ROOT / ".github" / "workflows"
LAB_WORKFLOWS = [
    WORKFLOW_DIRECTORY / "ci.yml",
    WORKFLOW_DIRECTORY / "sast.yml",
    WORKFLOW_DIRECTORY / "bandit.yml",
]

USES_REFERENCE = re.compile(r"^\s*uses:\s*([^@\s]+)@([^\s#]+)", re.MULTILINE)
FULL_SHA = re.compile(r"^[0-9a-f]{40}$")


class WorkflowSecurityTests(unittest.TestCase):
    def test_expected_workflows_exist(self) -> None:
        for path in LAB_WORKFLOWS:
            with self.subTest(path=path.name):
                self.assertTrue(path.is_file())

    def test_actions_are_pinned_to_full_commit_shas(self) -> None:
        for path in LAB_WORKFLOWS:
            text = path.read_text(encoding="utf-8")
            references = USES_REFERENCE.findall(text)
            with self.subTest(path=path.name):
                self.assertGreater(len(references), 0)
                for action, revision in references:
                    self.assertRegex(
                        revision,
                        FULL_SHA,
                        msg=f"{action} is not pinned to a full commit SHA",
                    )

    def test_checkout_does_not_persist_credentials(self) -> None:
        for path in LAB_WORKFLOWS:
            text = path.read_text(encoding="utf-8")
            with self.subTest(path=path.name):
                self.assertIn("persist-credentials: false", text)

    def test_workflows_avoid_unsafe_triggers_and_aws_credentials(self) -> None:
        for path in LAB_WORKFLOWS:
            text = path.read_text(encoding="utf-8")
            with self.subTest(path=path.name):
                self.assertNotIn("pull_request_target:", text)
                self.assertNotRegex(text, r"AWS_(?:ACCESS_KEY|SECRET_ACCESS_KEY|SESSION_TOKEN)")
                self.assertIn("permissions:\n  contents: read", text)


if __name__ == "__main__":
    unittest.main()
