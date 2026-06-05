---
name: drift-guard-protocol
description: "Anti-drift re-grounding rule — on any task running past 2-3 minutes, periodically re-read the user's original request, detect scope drift, and fall back to what was actually asked."
triggers: ["drift guard", "stay on task", "scope drift", "re-anchor", "off topic", "gone too far", "follow my instruction", "long task checkpoint"]
version: 1.0
status: authoritative
date_updated: "2026-05-21"
---

# 🧭 DRIFT GUARD PROTOCOL (V1.0)

User mandate: *"Don't run too far away. Always follow my instruction. Every 2-3 minutes, re-read my original request and check if you've gone too far — if so, fall back to what I asked."*

This protocol keeps execution anchored to the user's actual request. It applies to **every** task expected to run longer than ~2-3 minutes, in any lane (Lean Fast or Deep Capability).

---

## 1. THE ANCHOR

The **Anchor** is the user message that *started the current task* — "the chat where it starts."

- At the beginning of any non-trivial task, identify the Anchor and hold it.
- The Anchor is the success contract: the task is done when the Anchor is satisfied — no more, no less.
- A **new explicit user request** mid-conversation becomes the **new Anchor**. Casual confirmations ("ok", "yes", "go on") do NOT reset the Anchor — they continue the existing one.

---

## 2. CHECKPOINT CADENCE

Re-ground roughly **every 2-3 minutes of work**. Since wall-clock time is not directly observable, operationalize as — whichever comes first:

- every **3-5 tool-call batches**, OR
- at **every phase / step boundary** (e.g., between EXECUTION LOOP phases, between numbered skill steps), OR
- before any action that **expands scope** (new file, new feature, new dependency, refactor).

A short task that finishes inside one checkpoint window needs no checkpoint.

---

## 3. CHECKPOINT PROCEDURE

At each checkpoint, run silently (no user-facing noise unless drift is found):

1. **RE-READ THE ANCHOR.** Re-read the original request verbatim — do not rely on memory of it.
2. **COMPARE.** Ask: *Is what I am doing right now what was asked?* Check for:
   - scope creep (building beyond the request),
   - topic drift (solving an adjacent problem, not the asked one),
   - unrequested changes (extra files, refactors, "improvements"),
   - lost constraints (a rule from the Anchor I stopped honoring).
3. **CLASSIFY DRIFT:**
   - `on-track` — current work maps cleanly to the Anchor → continue.
   - `minor-drift` — small overreach or tangent → trim back now, note it in one line, continue.
   - `major-drift` — working on the wrong thing / well outside the Anchor → trigger §4 Fallback.

---

## 4. FALLBACK ACTION (on `major-drift`)

1. **STOP** the current direction immediately. Do not finish the off-track work.
2. **REVERT** to the last `on-track` state (discard or set aside drifted changes).
3. **RESTATE** the Anchor in one line to re-establish the contract.
4. **RESUME** from the last on-track point, doing only what the Anchor asked.
5. **REPORT** the drift to the user in one short line: what drifted, and the correction.

Fallback favors *doing the asked thing correctly* over *salvaging unrequested work*.

---

## 5. WHAT THIS IS NOT

- **Not** a permission gate — do not stop and ask the user at every checkpoint. Checkpoints are silent self-audits; surface only real drift.
- **Not** a literal timer — "2-3 minutes" is a cadence target, approximated by tool-batch / phase boundaries.
- **Not** a reason to under-deliver — fully completing the Anchor's scope is on-track, not drift. Drift is work *outside* the Anchor.

---

## 6. INTEGRATION

- Layered over `GROUND_KERNEL.md` §2 EXECUTION LOOP — the checkpoint runs at phase boundaries (HYDRATE → GROUND → PLAN → ACT → VERIFY).
- Compact always-on trigger lives in [`00_REASONING_EVOLUTION_PROTOCOL.md`](../../00_REASONING_EVOLUTION_PROTOCOL.md) Rule 11, so it loads at startup without reading this full file.
- Extends Reasoning Rule 1 (Goal Contract First): Rule 1 sets the contract once; Drift Guard re-verifies it periodically.

---
**Drift Guard V1.0 — Antigravity Tier-1 Governance // 2026-05-21**
