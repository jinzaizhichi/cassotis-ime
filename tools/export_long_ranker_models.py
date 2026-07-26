#!/usr/bin/env python3
"""Export trained long-sentence search and reranker reports to Pascal units."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path


SEARCH_FEATURES = (
    ("char_lm_score", "char_lm_score", 1),
    ("original_rank", "original_rank", 1),
    ("base_score", "base_score", 1),
    ("word_lm_head_bonus", "word_lm_head_bonus", 1),
    ("word_lm_full_bonus", "word_lm_full_bonus", 1),
    ("segments", "segments", 1),
    ("single_segments", "single_segments", 1),
    ("first_chunk_units", "first_chunk_units", 1),
    ("anchor_units", "anchor_units", 1),
    ("has_anchor", "Ord(has_anchor)", 1),
)
SECOND_STAGE_FEATURES = (
    ("first_stage_score", "first_stage_score", 1),
    ("char_lm_score", "char_lm_score", 1),
    ("word_lm_bonus", "word_lm_bonus", 1),
    ("base_score", "base_score", 1),
    ("segments", "segments", 1),
    ("single_segments", "single_segments", 1),
    ("max_segment_units", "max_segment_units", 1),
    ("anchor_units", "anchor_units", 1),
    ("has_anchor", "Ord(has_anchor)", 1),
)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--search-report", required=True, type=Path)
    parser.add_argument("--second-stage-report", required=True, type=Path)
    parser.add_argument("--output-dir", required=True, type=Path)
    return parser.parse_args()


def load_report(path: Path) -> tuple[dict, str]:
    raw = path.read_bytes()
    return json.loads(raw.decode("utf-8")), hashlib.sha256(raw).hexdigest().upper()


def pascal_expression(
    coefficients: dict[str, int],
    features: tuple[tuple[str, str, int], ...],
    first_prefix: str,
) -> str:
    lines = []
    for index, (name, expression, denominator) in enumerate(features):
        coefficient = coefficients[name]
        magnitude = abs(coefficient)
        term = f"Int64({expression})"
        if magnitude != 1:
            term += f" * {magnitude}"
        if denominator != 1:
            term += f" div {denominator}"
        if index == 0:
            sign = "-" if coefficient < 0 else ""
            lines.append(f"{first_prefix}{sign}{term}")
        else:
            sign = "-" if coefficient < 0 else "+"
            lines.append(f"        {sign} {term}")
    lines[-1] += ";"
    return "\n".join(lines)


def render_search_model(report: dict, report_hash: str) -> str:
    coefficients = {
        name: int(value)
        for name, value in report["integer_coefficients"].items()
    }
    expression = pascal_expression(
        coefficients, SEARCH_FEATURES, "    Result := "
    )
    return f"""unit nc_long_search_ranker_model;

interface

function long_search_ranker_score(const char_lm_score: Integer;
    const original_rank: Integer; const base_score: Integer;
    const word_lm_head_bonus: Integer; const word_lm_full_bonus: Integer;
    const segments: Integer; const single_segments: Integer;
    const first_chunk_units: Integer; const anchor_units: Integer;
    const has_anchor: Boolean): Int64;

implementation

function long_search_ranker_score(const char_lm_score: Integer;
    const original_rank: Integer; const base_score: Integer;
    const word_lm_head_bonus: Integer; const word_lm_full_bonus: Integer;
    const segments: Integer; const single_segments: Integer;
    const first_chunk_units: Integer; const anchor_units: Integer;
    const has_anchor: Boolean): Int64;
begin
    // Joint pairwise model trained on independent long-sentence corpora.
    // Model report SHA-256: {report_hash}
{expression}
end;

end.
"""


def render_second_stage_model(report: dict, report_hash: str) -> str:
    coefficients = {
        name: int(report["integer_coefficients"][name])
        for name, _expression, denominator in SECOND_STAGE_FEATURES
    }
    thresholds = report["promotion_thresholds"]
    constraints = report["promotion_constraints"]

    def threshold_expression(name: str) -> str:
        value = int(thresholds[name])
        if value == 2**63 - 1:
            return "High(Int64)"
        return str(value)

    expression = pascal_expression(
        coefficients, SECOND_STAGE_FEATURES, "    Result := "
    )
    return f"""unit nc_long_second_stage_ranker_model;

interface

const
    c_long_second_stage_ranker_rank1_min_char_lm_gain: Integer = {int(constraints["rank_1_min_char_lm_gain"])};
    c_long_second_stage_ranker_rank1_threshold: Int64 = {threshold_expression("rank_1")};
    c_long_second_stage_ranker_rank3_threshold: Int64 = {threshold_expression("rank_3")};
    c_long_second_stage_ranker_rank5_threshold: Int64 = {threshold_expression("rank_5")};

function long_second_stage_ranker_score(const first_stage_score: Integer;
    const char_lm_score: Integer; const word_lm_bonus: Integer;
    const base_score: Integer; const segments: Integer;
    const single_segments: Integer; const max_segment_units: Integer;
    const anchor_units: Integer; const has_anchor: Boolean): Int64;

implementation

function long_second_stage_ranker_score(const first_stage_score: Integer;
    const char_lm_score: Integer; const word_lm_bonus: Integer;
    const base_score: Integer; const segments: Integer;
    const single_segments: Integer; const max_segment_units: Integer;
    const anchor_units: Integer; const has_anchor: Boolean): Int64;
begin
    {{ Pairwise quality model trained on independent novel, chat, and formal
      long-sentence candidates. Calibrated rank gates only promote an expanded
      search state when it clears every observed regression margin.
      Model report SHA-256:
      {report_hash} }}
{expression}
end;

end.
"""


def main() -> int:
    args = parse_args()
    search_report, search_hash = load_report(args.search_report)
    second_report, second_hash = load_report(args.second_stage_report)
    args.output_dir.mkdir(parents=True, exist_ok=True)
    search_path = args.output_dir / "nc_long_search_ranker_model.pas"
    second_path = args.output_dir / "nc_long_second_stage_ranker_model.pas"
    search_path.write_text(
        render_search_model(search_report, search_hash), encoding="ascii"
    )
    second_path.write_text(
        render_second_stage_model(second_report, second_hash), encoding="ascii"
    )
    print(search_path.resolve())
    print(second_path.resolve())
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
