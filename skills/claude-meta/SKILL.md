---
name: claude-meta
description: "Sovereign Meta-Orchestrator. Enforces the Plan → Execute → Validate loop for any non-trivial change. Mandatory handshake before touching Tier-0/1 assets."
triggers: ["claude-meta", "meta", "planning", "plan-first", "plan stop approve", "handshake", "validate knowledge", "audit", "post-mortem", "before code", "agentic loop"]
phase: 0-orchestrator
requires: []
unlocks: [plan-first, validate-knowledge]
inputs: [user_intent, target_tier, scope]
output_format: structured_plan_then_execute_then_audit
model_hint: gpt-5.5
version: 2.1
status: authoritative
date_created: "2026-04-16"
date_updated: "2026-04-24"
---

# `claude-meta` — Sovereign Meta-Orchestrator (V2.1)

**Plan → Execute → Validate**. Wraps every non-trivial Sovereign action. Aligns with [GROUND_KERNEL.md](../../memories/0_apex/GROUND_KERNEL.md) Principle 9 and [KARPATHY_OPERATIONAL_STANDARD.md](../../memories/0_apex/GROUND_KERNEL.md).

---

## ⚖️ WHEN TO INVOKE

Mandatory if ANY:
- Touching ≥2 files in one change
- Touching Tier-0 (Apex / ATLAS / Claude skills) or Tier-1 (`1_core/`, `2_governance/`)
- Schema / RLS / auth-flow change
- New module / route / entity

Skip if: single-file Tier-2/3 edit ≤ 20 lines — use [AOE_PROTOCOL](../../memories/archive/AOE_PROTOCOL.md) surgical intent.

---

## 🚀 THE 3-PHASE LOOP

### Phase 1 — PLAN (gpt-5.5)
Invoke **[plan-first/skill.md](./plan-first/skill.md)**. Output: HUD Implementation Plan (intent · success criteria · skill chain · micro-verifications · rollback · tier per file). Persisted to `brain/tactical/plan_{timestamp}.md`.

### Phase 2 — STOP & HANDSHAKE
No execution until handshake. Gate by tier:

| Tier | Gate | User must say |
|---|---|---|
| **0** (Apex / ATLAS / `claude/`) | Challenge-Response | exact challenge string |
| **1** (`1_core/`, `2_governance/`) | Plan-Stop-Approve | "go" / "approve" / "apply" |
| **2** (other knowledge/skills) | Shadow Drafting | "go" after diff preview |
| **3** (project source) | Surgical Intent | implicit; stated upfront |

Handshake expires after 3 turns of silence ([AOE_PROTOCOL](../../memories/archive/AOE_PROTOCOL.md)).

### Phase 3 — EXECUTE (gpt-5.4-mini)
Per skill-chain step:
1. **ACT** — surgical change on named lines only
2. **MICRO-VERIFY** — run the plan's checkpoint command
3. **OBSERVE** — print PASS/FAIL with actual exit code
4. On FAIL → **STOP**, offer rollback, re-enter Phase 1

### Phase 4 — VALIDATE (gpt-5.4-mini)
Invoke **[validate-knowledge/skill.md](./validate-knowledge/skill.md)**. Runs: frontmatter check · path-ref integrity · cross-ref resolution · secret scanner · screenshot hygiene ([SCREENSHOT_HYGIENE.md](../../memories/2_governance/SCREENSHOT_HYGIENE.md)). `>20` violations → HALT + escalate as Critical Drift.

---

## 🤝 HANDSHAKE TEMPLATE

```markdown
[🔪 APEX PLAN] | [⚡ MODE: {recipe}] | [🎯 TIER: {0|1|2|3}]

## INTENT
{one sentence}

## FILES & TIERS
| File | Tier | Action |

## MICRO-VERIFICATION
- [ ] `{command}` → expect {state}

## ROLLBACK
- {undo per failure point}

[⚡ STATUS: PENDING_APPROVAL] · Reply "go" (Tier-0 requires challenge above)
```

---

## 🔁 SCP MANDATE

Every Phase-1 plan comparing ≥2 paths MUST include the [SCP](../../memories/2_governance/MODULE_AUDIT_PROTOCOL.md) table:

| Option | Token Spend | Token Cost | Speed Time | Speed % | Rating /10 |

Pick highest Rating, justify in one sentence, proceed.

---

## 🛡️ GUARDRAILS

- **Zero speculation** — solve only the immediate goal
- **Surgicality** — touch only files the plan named; adding files mid-execute → STOP, re-plan
- **Reality-bound** — PASS/FAIL must be a real exit code, not a vibe
- **No silent escalation** — if a Tier-1 file surfaces mid-execute, halt and re-handshake
- **Lossless re-entry** — plan + step pointer must survive user interrupts in `brain/tactical/`

---

## 🔗 RELATED

[plan-first](./plan-first/skill.md) · [validate-knowledge](./validate-knowledge/skill.md) · [AOE_PROTOCOL](../../memories/archive/AOE_PROTOCOL.md) · [KARPATHY](../../memories/0_apex/GROUND_KERNEL.md) · [SCREENSHOT_HYGIENE](../../memories/2_governance/SCREENSHOT_HYGIENE.md)

---
**V2.1 trimmed 2026-04-24** — removed verbose HUD examples and redundant prose; protocol logic intact.

