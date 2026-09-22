"""Run all offline synthetic validations and return a process status."""

from __future__ import annotations

from detection_engine import expected_fixture_results


def main() -> int:
    results = expected_fixture_results()
    for detection_id, matched in sorted(results.items()):
        print(f"{detection_id}: {'PASS' if matched else 'FAIL'} (synthetic)")
    return 0 if all(results.values()) else 1


if __name__ == "__main__":
    raise SystemExit(main())

