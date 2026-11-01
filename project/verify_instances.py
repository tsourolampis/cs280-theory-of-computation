#!/usr/bin/env python3
"""Validate the shipped DFA JSON files and (when available) their hashes."""

from __future__ import annotations

import argparse
import hashlib
import json
from collections import deque
from pathlib import Path
from typing import Any


def validate_instance(dfa: dict[str, Any]) -> None:
    if dfa.get("format") != "cs280-dfa-v1":
        raise ValueError("unsupported or missing format")
    n = dfa["num_states"]
    alpha = dfa["alphabet"]["size"]
    if not isinstance(n, int) or n <= 0:
        raise ValueError("num_states must be positive")
    if not isinstance(alpha, int) or alpha <= 0:
        raise ValueError("alphabet size must be positive")
    if dfa["start_state"] not in range(n):
        raise ValueError("invalid start_state")
    accepting = dfa["accepting_states"]
    if len(set(accepting)) != len(accepting) or any(q not in range(n) for q in accepting):
        raise ValueError("invalid accepting_states")
    rows = dfa["transitions"]
    if len(rows) != n:
        raise ValueError(f"expected {n} transition rows, got {len(rows)}")
    for q, row in enumerate(rows):
        if len(row) != alpha:
            raise ValueError(f"state {q}: expected {alpha} entries, got {len(row)}")
        if any((not isinstance(r, int)) or r < 0 or r >= n for r in row):
            raise ValueError(f"state {q}: transition target out of range")

    # Reachability is deliberately guaranteed by the generator and checked here.
    seen = {dfa["start_state"]}
    todo = deque(seen)
    while todo:
        q = todo.popleft()
        for r in rows[q]:
            if r not in seen:
                seen.add(r)
                todo.append(r)
    if len(seen) != n:
        raise ValueError(f"only {len(seen)}/{n} states are reachable")


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("directory", nargs="?", type=Path, default=Path(__file__).with_name("instances"))
    args = parser.parse_args()
    manifest_path = args.directory / "manifest.json"
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))

    for entry in manifest["instances"]:
        path = args.directory / entry["file"]
        actual_hash = sha256(path)
        if actual_hash != entry["sha256"]:
            raise SystemExit(f"HASH MISMATCH: {path.name}")
        dfa = json.loads(path.read_text(encoding="utf-8"))
        validate_instance(dfa)
        print(
            f"OK  {path.name:<32} n={dfa['num_states']:<4} "
            f"family={dfa['generator']['family']}"
        )

    print(f"\nAll {len(manifest['instances'])} instances are valid and match the manifest.")


if __name__ == "__main__":
    main()
