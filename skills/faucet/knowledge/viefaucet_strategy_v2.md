---
name: viefaucet-strategy-v2
description: "Viefaucet Strategy — V4.3 (Manual Faucet Priority)"
triggers: ["viefaucet strategy v2", "viefaucet_strategy_v2", "viefaucet strategy manual"]
phase: reference
model_hint: gpt-5.3-codex
version: 42.0
_ohdy_wrapper: |-
  # OHDY COMPRESSED NODE (V42.0)
  <dna_node>
  v: 42.0
  n: viefaucet_strategy_v2
  graph:
    req: []
    rel: []
  l: |-
  </dna_node>
status: archived
auto_load: false
archived_date: "2026-04-24"
---

# Viefaucet Strategy — V4.3 (Manual Faucet Priority)

PURPOSE: Drive AI Faucet Brain V4 with high-yield, priority-based earning.
V4.3: Added Faucet-First priority (5-min cycle) and PTC fallback logic.

## 1. PERFORMANCE METRICS (TPS)
| Earning Channel | Avg. Tokens | Avg. Time | Tokens / Sec (TPS) | Priority |
| :--- | :--- | :--- | :--- | :--- |
| TURBO PTC (Tier 1) | ~20 | ~5s | 4.00 | ⭐⭐⭐⭐⭐ (P1) |
| SAFE PTC (Tier 2) | ~20 | ~8s | 2.50 | ⭐⭐⭐⭐ (P2) |
| Manual Faucet | 65 | 300s | 0.22 | ⭐⭐⭐⭐⭐⭐ (P0) |

## 2. THE CHALLENGE ROADMAP (ACTIVE)
- DAILY 50: Target 50x PTC Claims and 50x Faucet Claims.
- FAUCETP0TICKER: Mandatory check every 5 minutes (300s).

## 3. PRIORITY PIPELINE
1. Faucet-First: Complete `/app/faucet` once every 300s.
2. PTC Cycle: Perform missions ONLY while Faucet timer > 0.
3. Watchdog Recovery: Active focus monitoring on background tabs.
4. Milestone harvesting: Automatic claim of rewards in `/app/challenge`.

---

V4.3 Manual Faucet Priority Assets — 2026-04-01

