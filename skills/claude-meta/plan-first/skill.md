---
name: plan-first
description: "Sovereign Apex Orchestrator — Liquid-intent detection and surgical goal-mapping. Orchestrates all active logic domains (claude, claude-app, claude-website, normal) via Sovereign Logic Cascade. Phase 1 of the claude-meta loop. (V15.3)"
triggers: ["plan first", "build module", "new module", "start feature", "create crud", "ready to build", "full module", "new table", "new website", "frontend design", "webapp genesis", "before code", "plan stop approve"]
phase: 0-orchestrator
requires: []
unlocks: [analyze-schema, create-module, generate-supabase-schema, generate-store, generate-views, generate-route, generate-i18n, workflow-test, generate-e2e]
inputs: [user_intent, target_entity, project_context]
output_format: structured_plan_document
model_hint: gpt-5.5
version: 15.3
status: authoritative
date_created: "2026-04-16"
date_updated: "2026-04-23"
---

# plan-first — Sovereign Apex Orchestrator (V15.2)

## ⚖️ THE APEX MANDATE
**Think, Simple, Surgical, Goal-Driven.**
Upfront reasoning is non-negotiable. Plan first, stop for approval, then execute with terminal-verified reality.

## Steps

### Step 0 — NOISE REDUCTION (PRINCIPLE 13)
Inject or verify `.codexignore` at project root. Ensure current session is isolated from background noise (logs, metadata) before starting the logic cascade.

### Step 1 — SOVEREIGN LOGIC CASCADE (RECURSIVE)

Instead of linear matching, use recursive path verification:
1. **Identify Target**: Verify exists via `Test-Path` or `GLOBAL_ATLAS.yaml`.
2. **Domain Mapping (APEX V15.3)**:
   - *Logic / Backend / Auth / Supabase schemas*: Route to `skills/claude/`
   - *Vue 3 mobile / PWA apps (13-step)*: Route to `skills/claude-app/`
   - *PHP + Supabase REST websites (13-step)*: Route to `skills/claude-website/`
   - *General design / research / testing*: Route to `skills/normal/`
   - *Web-Automation*: `skills/faucet/` **[deprecated — archived, user-confirmation required]**
3. **Signature Scan**: Match user tokens against [ATLAS.yaml](../../../knowledge/ATLAS.yaml) trigger keywords (Principle 10 — Navigation Mastery).
4. **Reality Check**: If target logic exists, compare current state with goal. If 100% parity, STOP (Simplicity First).

### Step 1.5 — SOVEREIGN COMPARISON (when ≥2 paths exist)

If the Logic Cascade surfaces **more than one viable recipe**, emit the mandatory SCP table before picking a winner (per [SOVEREIGN_COMPARISON_PROTOCOL.md](../../../knowledge/2_governance/SOVEREIGN_COMPARISON_PROTOCOL.md)):

| Option | Token Spend | Token Cost | Speed Time | Speed % | Rating /10 |
|---|---|---|---|---|---|
| A | … | … | … | … | … |
| B | … | … | … | … | … |

Pick the highest Rating. Justify selection in one sentence. Proceed to Step 2.

### Step 2 — LOAD RECIPE
Map the winning intent to a Skill Chain from the authoritative Atlas.

### Step 3 — BUILD PLAN DOCUMENT (APEX HUD)

Fill this template (Clinical HUD format):

```markdown
# [🔪 APEX PLAN] | [⚡ MODE: {recipe_name}] | [🎯 GOAL: {target_entity}]

## ⚖️ INTENT & SUCCESS CRITERIA
- **Intent**: {one sentence restating goal}
- **Success Criteria**: {verifiable terminal state}

## 🧬 SOVEREIGN LOGIC CASCADE
1. {skill-name} — {surgical action}
2. ...

## 🏗️ MICRO-VERIFICATION CHECKPOINTS
- [ ] **Check 1**: Run {command} to verify {state}
- [ ] **Check 2**: Run {command} to verify {state}

## 🛡️ ROLLBACK PROTOCOL
- Failure at Step {N} -> {undo action}

[⚡ STATUS: PENDING_APPROVAL]
> **Reply "go" to execute.**
```

### Step 4 — PRESENT + STOP
Output the plan. DO NOT proceed until user handshake received.

### Step 5 — EXECUTION & MICRO-VERIFICATION
For each step in the cascade:
1. Execute surgical change.
2. **Micro-Verify**: Run terminal check (`node -l`, `php -l`, `Test-Path`).
3. If Pass -> Log checkpoint.
4. If Fail -> STOP immediately. Offer rollback.

### Step 5.5 — SCREENSHOT PURGE (if browser_subagent invoked)

If any step invoked `browser_subagent`, vision tool, or screenshot capture:

1. Extract textual findings (OCR / coords / DOM state) into the step log.
2. Purge the screenshot immediately — do NOT wait for session close:
   ```powershell
   Remove-Item "C:\Users\user\.codex\sessions\{session-uuid}\.tempmediaStorage" -Recurse -Force -ErrorAction SilentlyContinue
   ```
3. Verify the folder is gone before moving to the next step.

Full rule: [SCREENSHOT_HYGIENE.md](../../../knowledge/2_governance/SCREENSHOT_HYGIENE.md).

### Step 6 — FINAL HUD REPORT
Generate a clinical summary of files touched and verification status.

## Output Contract
Plan saved to `C:/Users/User/.codex/brain/tactical/plan_{timestamp}.md`.

## Guardrails
- **Zero speculation**: Solve only the immediate goal.
- **Surgicality**: Touch ONLY the files needed for the success criteria.

---
**plan-first V15.3 — 2026-04-23 · Karpathy Apex Edition (SCP + Screenshot-Hygiene integrated)**

