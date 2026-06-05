thread_id: 019e72d2-f758-76b2-9ae4-e7ef3508d269
updated_at: 2026-05-29T10:08:42+00:00
rollout_path: C:\Users\user\.codex\sessions\2026\05\29\rollout-2026-05-29T16-21-37-019e72d2-f758-76b2-9ae4-e7ef3508d269.jsonl
cwd: \\?\C:\Users\user\.codex
git_branch: main

# Built and validated a `.codex` performance benchmark plus a live prompt pack, then used it to harden routing and remove the last meaningful legacy reference noise.

Rollout context: The user wanted the `.codex` system improved, then asked to build a benchmark harness, expand it with live prompt tests, and clean remaining legacy references. Work stayed in `C:\Users\user\.codex` and focused on boot/routing files, governance docs, and benchmark tooling.

## Task 1: Build the benchmark harness and live prompt pack

Outcome: success

Preference signals:
- when the user asked for "comparison tables before and after" and later asked "how much improve now" / "how to become 10/10 rating", they want measurable performance reporting with concrete tokens/speed/rating deltas instead of vague claims -> future `.codex` improvements should default to benchmarkable metrics and clear before/after tables.
- when the user said "ok help me build this", they wanted implementation, not just advice -> future benchmark-related asks should be turned into actual files/scripts by default.

Key steps:
- Confirmed the current benchmark was only a manual checklist in `00_CODEX_PERF_BENCHMARK.md`.
- Added `codex-router/perf-benchmark.json` as the offline deterministic case set.
- Added `codex-router/Test-CodexPerfBenchmark.ps1` to score routing, noise exclusion, audit health, and benchmark expectations.
- Added `codex-router/live-benchmark-prompts.json` for real model runs after major `.codex` changes.
- Updated `00_CODEX_PERF_BENCHMARK.md` to document the live prompt pack and the capture template.

Failures and how to do differently:
- The first benchmark runner failed because optional JSON arrays were being treated as single empty items in PowerShell. The fix was to only check optional fields when they actually exist.
- An initial broad patch against older memory files hit encoding/line-shape mismatches. Smaller exact patches were safer.

Reusable knowledge:
- The benchmark should separate offline deterministic checks from live model measurements: offline for routing health, live prompts for token/time/quality.
- Real model measurements should record model name, timestamps, prompt/completion/total tokens, wall-clock seconds, route correctness, and answer quality.
- Benchmark acceptance should require both a passing audit and a passing benchmark run.

References:
- [1] `codex-router/perf-benchmark.json` added with cases such as `boot-pulse-only`, `sentinel-knowledge`, `design-app-route`, `gitnexus-policy-route`, `relation-autoguard-route`, `twenty-eighty-context-rule`, `archive-noise-excluded`, and `route-integrity-rule`.
- [2] `codex-router/Test-CodexPerfBenchmark.ps1` added; final verified output: `Rating: 10/10`, `Passed: 12`, `Failed: 0`, `Safe indexed files: 346`, `Knowledge routes: 75`.
- [3] `codex-router/live-benchmark-prompts.json` added with a reusable prompt pack for real LLM measurements.

## Task 2: Align routing/audit rules and remove legacy noise

Outcome: success

Preference signals:
- when the user said the system should be aware of "router route path of the changes or merged content or files and folder route" and not break knowledge during updates, that indicates route integrity must be treated as a hard rule -> future merges/archives/deletes should update all references or leave redirect stubs before considering the change complete.
- when the user later answered "1. skip 2. ok 3.skip 4.ok 5.ok 6. skip", they were selectively approving only the useful automation and cleanup tasks -> future work should stay tightly scoped and skip speculative extras.

Key steps:
- Added route-integrity language to hot boot/governance files earlier in the session, then extended the benchmark docs to reference the live prompt pack.
- Updated `codex-router/Audit-CodexRouting.ps1` so excluded paths like archive/history do not inflate legacy scans.
- Cleaned active docs that still used old `gemini-3-flash`/`gemini` model metadata or old `.gemini` phrasing in route-sensitive places.
- Re-ran router update, audit, and benchmark after each meaningful change.

Failures and how to do differently:
- The initial exclude matcher in the audit script was too complex and accidentally failed to exclude `memories/raw_memories.md`; simplifying the path normalization and `-like` matching fixed the false positives.
- The first legacy count looked high because the audit was still scanning cold history and old references in files that were effectively excluded from normal routing. After aligning the audit with the router excludes and cleaning active docs, the legacy count became meaningful.

Reusable knowledge:
- `Audit-CodexRouting.ps1` must use the same exclusion logic as `router-config.json`, or legacy counts will be inflated by cold history.
- `raw_memories.md`, `archive/`, and `rollout_summaries/` should stay out of normal routing/audit noise, while still remaining on disk for explicit lookup.
- Route integrity remains the key rule: after path moves or merges, update routes, regenerate routing, then audit.

References:
- [1] `codex-router/Audit-CodexRouting.ps1` updated to exclude configured cold-history paths during scans.
- [2] `00_CODEX_PERF_BENCHMARK.md` now links the live prompt pack and documents manual capture fields.
- [3] `codex-router/live-benchmark-prompts.json` added for live tests.
- [4] Active docs modernized away from old Gemini-era metadata, including `memories/0_apex/HYBRID_FORMAT_PROTOCOL.md`, `memories/CLAUDE_BLUEPRINT_RECIPE.md`, `memories/IMAGE_TO_MOBILE_APP_PIPELINE.md`, `memories/MOBILE_APP_DESIGN_RECIPE.md`, `memories/1_core/HEADER_FOOTER_DESIGN_RULES.md`, `memories/1_core/IMAGE_SOURCING_FREE.md`, `memories/2_governance/artifacts/AI_AGENT_KEYS.md`, `memories/2_governance/artifacts/CORE_VITALS.md`, `memories/2_governance/bridges/*`, `memories/2_governance/LAA_ECOSYSTEM_API_PROTOCOL.md`, `memories/2_governance/MODULE_AUDIT_PROTOCOL.md`, `memories/2_governance/sovereign_framework_mastery.md`, and `memories/2_governance/SOVEREIGN_BLUEPRINT_PROCEDURE.md`.

## Task 3: Verify the final state

Outcome: success

Preference signals:
- the repeated focus on improvement percentage, token cost, speed, and rating implies future `.codex` maintenance should keep returning those metrics by default -> benchmarks should stay numerical and repeatable.

Key steps:
- Regenerated routing after changes.
- Re-ran `codex-router/Audit-CodexRouting.ps1` and `codex-router/Test-CodexPerfBenchmark.ps1`.
- Confirmed final audit health and benchmark pass.

Failures and how to do differently:
- None remaining in the verified final state.

Reusable knowledge:
- Final verified state at the end of this rollout: `missing_mandatory_count=0`, `missing_fallback_count=0`, `missing_roots_count=0`, `legacy_ref_count=0`, benchmark `Rating: 10/10`, `Passed: 12`, `Failed: 0`.

References:
- [1] `codex-router/Audit-CodexRouting.ps1` final output: `legacy_ref_count: 0`.
- [2] `codex-router/Test-CodexPerfBenchmark.ps1` final output: `Rating: 10/10`, `Passed: 12`, `Failed: 0`.
- [3] `CODEX_DYNAMIC_ROUTING.md` regenerated with `Safe indexed files: 346` and `knowledge: 75 files`.
