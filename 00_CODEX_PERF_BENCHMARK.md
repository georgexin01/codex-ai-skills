# .codex Performance Benchmark

Purpose: measure whether `.codex` changes improve routing speed, token discipline, and correctness without breaking knowledge paths.

## Quick Run

```powershell
powershell -ExecutionPolicy Bypass -File codex-router\Test-CodexPerfBenchmark.ps1
```

The runner is offline and deterministic. It does not call an LLM. It checks the routing layer, trigger coverage, archive noise, and benchmark expectations.

## Current Targets

| Metric | Before | After Target | Delta / Notes |
|---|---|---|---|
| Token cost | est. ~8k-14k broad orientation | est. ~1k-2.5k routed orientation | Aim for ~70-85% drop |
| Speed | medium / route-ambiguous | very fast / deterministic route | Aim for +90-120% vs old state |
| Speed increase % | — | +90-120% | Estimated from fewer reads and smaller route surface |
| Rating | 8.8/10 current | 10/10 target | Requires benchmark pass + low route noise |

## Benchmark Cases

The source of truth is `codex-router/perf-benchmark.json`.
The live prompt pack for real model checks is `codex-router/live-benchmark-prompts.json`.

Case types:
- `boot`: PULSE-only startup and deferred canon.
- `sentinel`: `ai read .codex knowledge` returns ready sentinel after one route pass.
- `route`: trigger phrase maps to the expected file.
- `noise`: archive/raw/rollout history stays out of normal routing.
- `safety`: route integrity and audit pass after changes.

## Manual LLM Metrics

For real model runs, record these per task:
- Provider
- Model
- Lane used
- Reasoning setting used
- Prompt tokens
- Cached tokens when available
- Completion tokens
- Total tokens
- Estimated cost
- Wall-clock completion time
- Turns per task
- Route correctness score (1-10)
- Output quality score (1-10)

## Live Prompt Pack

Use `codex-router/live-benchmark-prompts.json` when we want real model measurements after `.codex` changes.

For each prompt, capture:
- provider
- model name
- lane used
- reasoning setting used
- run timestamp
- prompt tokens
- cached tokens
- completion tokens
- total tokens
- estimated cost usd
- wall-clock seconds
- route correctness (1-10)
- answer quality (1-10)
- drift / over-read notes

## Acceptance

A `.codex` optimization is accepted only when:
- `Test-CodexPerfBenchmark.ps1` passes.
- `Audit-CodexRouting.ps1` reports no missing mandatory/fallback/root entries.
- Active knowledge routes remain lean: archive, rollout summaries, and raw memory are excluded from normal routing.
- Any merged/deleted path has an updated route or an intentional redirect stub.
