import re
import unittest
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parents[1]
TEXT_SUFFIXES = {".md", ".json", ".py", ".sql", ".tf", ".tfvars", ".yml", ".yaml", ".mmd"}
IGNORED_NAMES = {".terraform.lock.hcl"}

REAL_ACCESS_KEY = re.compile(r"\b(?:AKIA|ASIA)[A-Z0-9]{16}\b")
PRIVATE_KEY = re.compile(r"-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----")
EMAIL = re.compile(r"\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b", re.IGNORECASE)
ACCOUNT_ID = re.compile(r"(?<![A-Z0-9_<])\d{12}(?![A-Z0-9_>])")
IPV4 = re.compile(r"\b(?:\d{1,3}\.){3}\d{1,3}\b")


def text_files() -> list[Path]:
    return [
        path
        for path in PROJECT_ROOT.rglob("*")
        if path.is_file()
        and path.suffix.lower() in TEXT_SUFFIXES
        and path.name not in IGNORED_NAMES
        and ".terraform" not in path.parts
    ]


def is_reserved_ip(value: str) -> bool:
    parts = [int(part) for part in value.split(".")]
    if any(part > 255 for part in parts):
        return False
    return (
        parts[:3] == [192, 0, 2]
        or parts[:3] == [198, 51, 100]
        or parts[:3] == [203, 0, 113]
        or parts[0] == 127
        or parts == [0, 0, 0, 0]
    )


class RepositorySafetyTests(unittest.TestCase):
    def test_no_credential_or_private_key_material(self) -> None:
        for path in text_files():
            text = path.read_text(encoding="utf-8")
            with self.subTest(path=path.relative_to(PROJECT_ROOT)):
                self.assertIsNone(REAL_ACCESS_KEY.search(text))
                self.assertIsNone(PRIVATE_KEY.search(text))

    def test_no_literal_email_addresses(self) -> None:
        for path in text_files():
            text = path.read_text(encoding="utf-8")
            with self.subTest(path=path.relative_to(PROJECT_ROOT)):
                self.assertIsNone(EMAIL.search(text))

    def test_no_literal_account_ids(self) -> None:
        for path in text_files():
            text = path.read_text(encoding="utf-8")
            with self.subTest(path=path.relative_to(PROJECT_ROOT)):
                self.assertIsNone(ACCOUNT_ID.search(text))

    def test_all_literal_ips_are_reserved(self) -> None:
        for path in text_files():
            text = path.read_text(encoding="utf-8")
            for match in IPV4.finditer(text):
                with self.subTest(path=path.relative_to(PROJECT_ROOT), ip=match.group()):
                    self.assertTrue(is_reserved_ip(match.group()))


if __name__ == "__main__":
    unittest.main()

