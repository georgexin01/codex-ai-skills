---
name: faucet-harvest-claim
description: "V1.0 Faucet Harvest & Claim logic. The execution layer for token acquisition."
triggers: ["harvest", "claim", "collect"]
phase: reference
version: 1.0
status: archived
auto_load: false
archived_date: "2026-04-24"
---

# `04-harvesting` — Faucet Harvest & Claim V1.0

## Purpose
The definitive execution step for token acquisition once all roadblocks are cleared.

## 🚀 The Protocol

1. **Gate Verification**: Confirm Step 03 (Solving) is 100% complete.
2. **Surgical Click**: Execute 'Claim' or 'Collect' interaction.
3. **Success Detection**: Wait for the "Success" toast or modal. Capture the reported reward value.
4. **Transition**: Immediately move to Step 05 (Ledgering).

## 🛠️ Mandatory Logic
- **BLOCK CHECK**: If "Claim" remains unclickable after solving, execute a surgical page refresh and re-run Step 03.

---
**Status**: V1.0 Active | **Requirement**: Collection
