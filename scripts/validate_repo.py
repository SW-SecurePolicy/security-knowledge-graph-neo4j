#!/usr/bin/env python3
from pathlib import Path
import csv
from collections import Counter, defaultdict

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data"

EXPECTED = {
    "frameworks.csv": 3,
    "domains.csv": 16,
    "categories.csv": 67,
    "controls.csv": 248,
    "primary_mapping.csv": 248,
    "secondary_mapping.csv": 58,
}

def read_csv(name):
    path = DATA / name
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))

def fail(msg):
    raise SystemExit(f"[FAIL] {msg}")

def main():
    tables = {name: read_csv(name) for name in EXPECTED}

    for name, expected in EXPECTED.items():
        actual = len(tables[name])
        if actual != expected:
            fail(f"{name}: expected {expected}, got {actual}")
        print(f"[OK] {name}: {actual}")

    framework_ids = {r["id"] for r in tables["frameworks.csv"]}
    domain_ids = {r["id"] for r in tables["domains.csv"]}
    category_ids = {r["category_id"] for r in tables["categories.csv"]}
    control_ids = {r["id"] for r in tables["controls.csv"]}

    if len(framework_ids) != 3:
        fail("framework id duplicate")
    if len(domain_ids) != 16:
        fail("domain id duplicate")
    if len(category_ids) != 67:
        fail("category id duplicate")
    if len(control_ids) != 248:
        fail("control id duplicate")

    for r in tables["categories.csv"]:
        if r["domain_id"] not in domain_ids:
            fail(f"unknown domain in categories.csv: {r}")

    framework_counts = Counter(r["framework"] for r in tables["controls.csv"])
    expected_framework_counts = {"CASP": 54, "ISMS-P": 101, "ISO27001": 93}
    if dict(framework_counts) != expected_framework_counts:
        fail(f"framework control counts mismatch: {dict(framework_counts)}")
    print(f"[OK] framework counts: {dict(framework_counts)}")

    primary_by_control = defaultdict(list)
    for r in tables["primary_mapping.csv"]:
        if r["control_id"] not in control_ids:
            fail(f"unknown control in primary_mapping.csv: {r}")
        if r["category_id"] not in category_ids:
            fail(f"unknown category in primary_mapping.csv: {r}")
        primary_by_control[r["control_id"]].append(r["category_id"])

    wrong_primary = {cid: cats for cid, cats in primary_by_control.items() if len(cats) != 1}
    missing_primary = sorted(control_ids - set(primary_by_control))
    if wrong_primary or missing_primary:
        fail(f"primary mapping integrity failed. wrong={wrong_primary}, missing={missing_primary[:10]}")
    print("[OK] every Control has exactly one primary mapping")

    seen_secondary = set()
    for r in tables["secondary_mapping.csv"]:
        pair = (r["control_id"], r["category_id"])
        if pair in seen_secondary:
            fail(f"duplicate secondary mapping: {pair}")
        seen_secondary.add(pair)
        if r["control_id"] not in control_ids:
            fail(f"unknown control in secondary_mapping.csv: {r}")
        if r["category_id"] not in category_ids:
            fail(f"unknown category in secondary_mapping.csv: {r}")
    print("[OK] secondary mapping references are valid")

    expected_nodes = 1 + 3 + 16 + 67 + 248
    expected_relationships = 16 + 67 + 248 + 248 + 58
    if expected_nodes != 335 or expected_relationships != 637:
        fail("internal count formula mismatch")
    print(f"[OK] expected Neo4j totals: nodes={expected_nodes}, relationships={expected_relationships}")
    print("\nRepository data validation passed.")

if __name__ == "__main__":
    main()
