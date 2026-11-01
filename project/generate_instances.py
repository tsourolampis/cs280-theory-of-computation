#!/usr/bin/env python3
"""Generate the deterministic CS280 DFA benchmark suite.

The generator uses only the Python standard library.  Every DFA is complete,
uses byte symbols 0..255, starts at state 0, and is made fully reachable by
reserving one symbol (default: byte 0) for a cycle through all states.

Two families are provided:
  * uniform: independent random transition rows;
  * planted_similarity: clusters of states copy a prototype row and then
    independently mutate entries.  This creates controlled transition-row
    similarity, which is useful for evaluating D2FA compression.

Designed for CS280 by Charalampos E. Tsourakakis.
Implementation generated with assistance from OpenAI Codex and subsequently
reviewed and adapted for the course.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import math
import random
import sys
from pathlib import Path
from typing import Any

FORMAT = "cs280-dfa-v1"


def choose_accepting_states(rng: random.Random, n: int, p: float) -> list[int]:
    accepting = [q for q in range(n) if rng.random() < p]
    if not accepting:
        accepting = [rng.randrange(n)]
    if len(accepting) == n and n > 1:
        accepting.pop()
    return sorted(accepting)


def enforce_reachability(transitions: list[list[int]], symbol: int) -> None:
    """Make every state reachable from state 0 using repeated `symbol`."""
    n = len(transitions)
    for q in range(n):
        transitions[q][symbol] = (q + 1) % n


def generate_uniform(
    *, n: int, alphabet_size: int, seed: int, accept_probability: float,
    reachability_symbol: int
) -> dict[str, Any]:
    rng = random.Random(seed)
    transitions = [
        [rng.randrange(n) for _ in range(alphabet_size)]
        for _ in range(n)
    ]
    enforce_reachability(transitions, reachability_symbol)
    accepting = choose_accepting_states(rng, n, accept_probability)
    return {
        "transitions": transitions,
        "accepting_states": accepting,
    }


def generate_planted_similarity(
    *, n: int, alphabet_size: int, seed: int, accept_probability: float,
    reachability_symbol: int, cluster_size: int, mutation_rate: float
) -> dict[str, Any]:
    if cluster_size <= 0:
        raise ValueError("cluster_size must be positive")
    if not 0.0 <= mutation_rate <= 1.0:
        raise ValueError("mutation_rate must be in [0,1]")

    rng = random.Random(seed)
    num_clusters = math.ceil(n / cluster_size)
    prototypes = [
        [rng.randrange(n) for _ in range(alphabet_size)]
        for _ in range(num_clusters)
    ]

    transitions: list[list[int]] = []
    for q in range(n):
        prototype = prototypes[q // cluster_size]
        row = prototype.copy()
        for a in range(alphabet_size):
            if rng.random() < mutation_rate:
                old = row[a]
                candidate = rng.randrange(n)
                if n > 1 and candidate == old:
                    candidate = (candidate + 1) % n
                row[a] = candidate
        transitions.append(row)

    enforce_reachability(transitions, reachability_symbol)
    accepting = choose_accepting_states(rng, n, accept_probability)
    return {
        "transitions": transitions,
        "accepting_states": accepting,
    }


def build_instance(spec: dict[str, Any], suite: dict[str, Any]) -> dict[str, Any]:
    n = int(spec["num_states"])
    alphabet_size = int(suite["alphabet_size"])
    reachability_symbol = int(suite["reachability_symbol"])
    accept_probability = float(suite["accept_probability"])
    seed = int(spec["seed"])
    family = spec["family"]

    common = dict(
        n=n,
        alphabet_size=alphabet_size,
        seed=seed,
        accept_probability=accept_probability,
        reachability_symbol=reachability_symbol,
    )
    if family == "uniform":
        generated = generate_uniform(**common)
    elif family == "planted_similarity":
        generated = generate_planted_similarity(
            **common,
            cluster_size=int(spec["cluster_size"]),
            mutation_rate=float(spec["mutation_rate"]),
        )
    else:
        raise ValueError(f"unknown family: {family!r}")

    metadata = {
        "family": family,
        "seed": seed,
        "reachability_symbol": reachability_symbol,
    }
    if family == "planted_similarity":
        metadata.update(
            cluster_size=int(spec["cluster_size"]),
            mutation_rate=float(spec["mutation_rate"]),
        )

    return {
        "format": FORMAT,
        "name": spec["name"],
        "alphabet": {
            "kind": "byte",
            "size": alphabet_size,
            "symbols": [0, alphabet_size - 1],
        },
        "num_states": n,
        "start_state": 0,
        "accepting_states": generated["accepting_states"],
        "transitions": generated["transitions"],
        "generator": metadata,
    }


def canonical_bytes(obj: dict[str, Any]) -> bytes:
    return (json.dumps(obj, indent=2, sort_keys=True) + "\n").encode("utf-8")


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--suite", type=Path, default=Path(__file__).with_name("instance_suite.json"),
        help="suite configuration JSON",
    )
    parser.add_argument(
        "--out", type=Path, default=Path(__file__).with_name("instances"),
        help="output directory",
    )
    parser.add_argument(
        "--only", action="append", default=[],
        help="generate only this named instance (repeatable)",
    )
    parser.add_argument("--list", action="store_true", help="list instance names and exit")
    args = parser.parse_args()

    suite = json.loads(args.suite.read_text(encoding="utf-8"))
    specs = suite["instances"]

    if args.list:
        for spec in specs:
            print(spec["name"])
        return 0

    selected = set(args.only)
    if selected:
        known = {spec["name"] for spec in specs}
        unknown = selected - known
        if unknown:
            parser.error("unknown instance(s): " + ", ".join(sorted(unknown)))
        specs = [spec for spec in specs if spec["name"] in selected]

    args.out.mkdir(parents=True, exist_ok=True)
    manifest_entries: list[dict[str, Any]] = []

    for spec in specs:
        instance = build_instance(spec, suite)
        payload = canonical_bytes(instance)
        filename = f"{spec['name']}.json"
        path = args.out / filename
        path.write_bytes(payload)
        digest = sha256_bytes(payload)
        manifest_entries.append(
            {
                "name": spec["name"],
                "file": filename,
                "sha256": digest,
                "family": spec["family"],
                "num_states": spec["num_states"],
                "alphabet_size": suite["alphabet_size"],
                "seed": spec["seed"],
            }
        )
        print(f"wrote {path}  sha256={digest[:16]}…")

    manifest = {
        "suite": suite["suite"],
        "format": suite["format"],
        "recommended_diameter_bounds": suite["recommended_diameter_bounds"],
        "instances": manifest_entries,
    }
    manifest_path = args.out / "manifest.json"
    manifest_path.write_text(json.dumps(manifest, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    print(f"wrote {manifest_path}")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (OSError, ValueError, KeyError, json.JSONDecodeError) as exc:
        print(f"error: {exc}", file=sys.stderr)
        raise SystemExit(2)
