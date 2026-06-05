---
name: pulse
description: "⚡ PULSE — single boot read. Hot rules + trigger map + reasoning profile in one file. Everything else is lazy/deferred."
triggers: ["ai", "boot", "start", "ai read .codex knowledge"]
phase: boot
model_hint: ["claude-code", "codex-gpt-5.3"]
version: 1.0
status: authoritative
supersedes_in_boot: ["00_CODEX_CUSTOM_INSTRUCTIONS_CODEX_BRIDGE.md", "CODEX_FULL_ACCESS_ROUTING.md"]
date_updated: "2026-06-02"
---

# ⚡ PULSE — Single Boot Read

The only file the boot needs. Consolidates the hot 20% of rules used 80% of the time, the trigger map, and the reasoning profile. Read this, resolve the route, act. Open anything else **only when the task needs it**. Rules here are pointers to canon, not new policy — output and behavior are unchanged.

## 0. Boot in one line
Read PULSE → resolve trigger below → load only the matched file. Manifest, stubs, and Tier-0 are **lazy** (§6).

Hydrate PULSE once per chat session, then reuse the in-session distilled context. Do not re-read PULSE or `.codex` knowledge on every message unless the user asks, routing becomes stale, or the task crosses into deep/governance/recovery risk.

## 0.1 Priority Ladder (non-negotiable)
When rules compete, obey this order:
1. **Safety and data sovereignty first** - never expose or mutate secrets, auth, tokens, sessions, cookies, live data, or destructive database/storage state unless the user explicitly asks and the action is safe.
2. **Truth before speed** - file state, tests, and logs beat memory and inference. If evidence is missing, say `INSUFFICIENT DATA` instead of guessing.
3. **Route before reading** - use PULSE triggers first, stop at the first valid match, and keep Tier-0 / manifests / rollouts deferred unless the task truly needs them.
4. **20/80 context compression** - preserve the top 20% mission-critical context verbatim; compress the remaining 80% into a compact form that keeps ~99% of meaning, evidence, and intent.
5. **Surgical action only** - change the smallest set of files/lines that solves the request; no unsolicited refactors, renames, migrations, or cleanup of knowledge/skills.
6. **Verify before done** - every edit needs read-back, smoke test, lint/build, SQL verification, or an explicit note explaining why verification could not run.
7. **User taste and project truth override generic defaults** - current project docs, schema, config, and `USER_DNA.md` beat generic framework habits.

## 1. Trigger Map (stop at first match)
```yaml
"ai read .codex knowledge": "respond ONLY '[🟢] Agent is Ready..' — skip summaries"
"ai claude":          "skills/claude/WORKING_PROGRESS.md"          # Vben Admin CRUD builder (owns schema)
"ai claude app":      "skills/claude-app/WORKING_PROGRESS.md"      # mobile Vue/Capacitor/PWA (build-only, mock-default)
"ai claude website":  "skills/claude-website/WORKING_PROGRESS.md"  # PHP + Supabase REST (consumes schema)
"<3-builder DB handshake>": "skills/SHARED_DB_CONTRACT.md"
"ai claude meta":     "skills/claude-meta/SKILL.md"
"ai design app":      "skills/design/app/SKILL.md"
"ai design website":  "skills/design/website/SKILL.md"
"ai design spec":     "skills/design/_spec/SKILL.md"               # DESIGN.md contract/lint
"ai karpathy":        "skills/karpathy-guidelines/SKILL.md"
"ai imagegen":        "skills/imagegen/SKILL.md"
"ai starting point":  "skills/starting-point/skill.md"
"ai clean module":    "skills/clean-module/skill.md"
"ai personality":     "skills/ai-personality/skill.md"
"ai user dna":        "memories/0_apex/USER_DNA.md"
"ai gitnexus":        "memories/2_governance/GITNEXUS.md"
"ai drift guard":     "memories/2_governance/DRIFT_GUARD_PROTOCOL.md"
"ai mode lean":       "memories/2_governance/MODEL_COST_OPTIMIZATION_POLICY.md"
"ai mode deep":       "memories/2_governance/MODEL_COST_OPTIMIZATION_POLICY.md"
"ai reply terse":     "memories/2_governance/MODEL_COST_OPTIMIZATION_POLICY.md"
"ai benchmark live":  "memories/2_governance/MODEL_COST_OPTIMIZATION_POLICY.md"
route_miss: "skills → memories/2_governance/artifacts/skill_path_router.md (semantic skill index). knowledge → grep memories/ by filename + frontmatter description/triggers. manifest = path/integrity index only (no descriptions) — never full-read."
```

Sentinel rule: `ai read .codex knowledge` performs route-first selective loading once per chat, stores compact in-session context, then replies only with the ready sentinel. Do not repeat the read on every message.

## 1.1 Rules Index (tiny map)
| Domain | Active rule | Deferred canon |
|---|---|---|
| Boot / trigger routing | `00_PULSE.md` | `00_CODEX_START_HERE.md` |
| Reasoning | PULSE §7 compact profile | `00_REASONING_EVOLUTION_PROTOCOL.md` |
| Deep governance / recovery | PULSE priority ladder | `memories/0_apex/GROUND_KERNEL.md` |
| Design | PULSE §5 must-follow + taste split | `memories/0_apex/USER_DNA.md` |
| Supabase / SQL | PULSE §4 hot rules | `memories/2_governance/LAA_ECOSYSTEM_API_PROTOCOL.md` |
| GitNexus | PULSE §4 / §4.1 project routing | `memories/2_governance/GITNEXUS.md` |
| Ignore / runtime cleanup | PULSE §8 after-edit rule | `memories/2_governance/CODEX_IGNORE_PROTOCOL.md`, `memories/2_governance/KNOWLEDGE_ROT_PROTOCOL.md` |

## 2. Execution Loop
HYDRATE (route, task-only reads) → GROUND (evidence: file state > tests > logs > memory > inference; never guess) → PLAN (surgical; for Tier-0/1 state blast radius) → ACT → VERIFY (smoke/lint/read-back every edit; on fail loop to PLAN).

Context rule: before spending tokens, identify the exact context that must remain unchanged (IDs, paths, schema, errors, user constraints, acceptance criteria). Keep that verbatim. Summarize supporting context aggressively only when the summary preserves ~99% of meaning and does not hide uncertainty.

## 3. Always-On Rules (the locks)
- **P0 Knowledge Freeze** — no structural/content change to `memories/` or `skills/` without explicit turn-by-turn approval. No unsolicited "improvements."
- **P16 Claude Skill Lock** — never rename/move any `claude*` skill folder unless user says "change claude skills."
- **Edit tiers**: T0 nuclear (`skills/claude*`, `GROUND_KERNEL`, `KARPATHY_TIER0_PRINCIPLES`, `codex-manifest.json`) = explicit confirm · T1 (`2_governance/`, `1_core/`, `00_*`) = plan-stop-approve · T2 = show intent/diff · T3 (project source) = surgical intent. Pending confirmation voids after 3 messages.
- **Karpathy-4**: think-first · simplicity-first · surgical (touch only required lines) · goal-driven verification. If 200 lines can be 50, rewrite.
- **Circuit breaker**: 3 failed fixes on same issue → STOP, switch to deep-audit.
- **Data sovereignty**: never expose PII/secrets/auth/token/cookie/session unless explicitly requested + safe.
- **Aesthetics**: follow Design DNA (§5). No ASCII art/bars, no emoji noise.

## 4. Engineering Defaults (the stack)
Vue 3 + TS + Pinia + Tailwind + Vben Admin + Supabase/Postgres · PHP for sites.
- **Casing bridge**: DB snake_case ↔ frontend/store camelCase — map at every boundary.
- **Schema isolation**: business data in its own schema, never `public`. Soft-delete `isDelete=false` everywhere. DB/core logic in the schema layer, not app wrappers.
- **Store-only**: views never call the API client directly — always via Pinia stores. Reads fail-soft, writes throw. Every call try/catch; Zod on forms.
- **4-layer auth**: `auth.users` → `public.user` (JWT hook injects `project_id`/`user_role`/`role_level`) → `{schema}.users` → `{schema}.drivers`. Check **`user_role`**, never `role` (PostgREST-reserved). RLS claim: `current_setting('request.jwt.claims',true)::jsonb->>'user_role'`.
- **SQL via file** (`docker cp` + `psql -f`), never inline `psql -c` (PowerShell strips quotes on camelCase idents).
- **Windows**: `npm.cmd` / `pnpm.cmd`. Dev servers run **background/detached** (foreground dies at turn end). Vben: `pnpm.cmd run dev:local` from panel root; port from `vite.config.mts` (angel = 6006). PHP: `php -S 127.0.0.1:<port> index.php`.
- **Supabase safety (ABSOLUTE)**: NEVER `supabase stop --no-backup` / `docker volume rm supabase_storage_*` / `docker system prune`. Safe: `supabase stop` (no flags), `start`, `db reset`.
- **GitNexus**: use when `.gitnexus/` exists, or auto-index once for a new large Vben/Supabase admin. Skip for PHP/static/small SPA.
- **GitNexus auto-index exception**: for new large Vben/Supabase admin projects, auto-run `gitnexus analyze` once when `.gitnexus/` is missing. Re-index after long/different updates when impact analysis would likely save time.

## 4.1 Project-Type Routing
| Project shape | Route |
|---|---|
| `.codex` knowledge / skills | PULSE first; targeted `memories/` or `skills/` reads only. Never GitNexus. Never full-read `codex-manifest.json` unless debugging routing drift. |
| Large Vben + Supabase admin | If `.gitnexus/` exists, use graph impact/context/query first. If new and missing, auto-run `gitnexus analyze` once. Re-run after long/structural updates when useful. |
| Supabase / schema / migration | Load SQL protocol only when needed; evidence ladder is mandatory; apply SQL from files, not inline PowerShell `psql -c`. |
| PHP/static/marketing site | Use docs + grep/glob/read. Skip GitNexus. Keep live content safe. |
| Mobile/PWA/small SPA | Use docs + grep/glob/read. Skip GitNexus unless user explicitly asks. Enforce viewport/safe-area/mobile rules. |

## 5. Design DNA ("Trusta Industrial")
**Must-follow rules**: 700 weight default (900 numbers-only, never <500) · 6px progress bars · headers **fixed not sticky**, ≤90px, pure `bg-white` + `.shadow-header` · BottomNav fixed ≤90px, icon+label, inactive `text-slate-400` · zero gray-on-gray · **no silent buttons** (dead CTA → "Coming soon" toast) · canonical Tailwind only (no arbitrary `[Npx]`) · viewport **always `width=device-width, initial-scale=1.0, viewport-fit=cover`** (never hardcode 412, no `maximum-scale`) · video URL fields platform-agnostic (no "YouTube") · Vben notification widget `false` unless backend wired · i18n strings in `/locales/*.json` only (literal CN/EN in templates = fail).

**Taste preferences**: glassmorphism for overlays/modals only · violet/teal/dark glow direction · clickable cards over plain buttons · compact industrial density · sharp contrast · `max-w-103`/412px desktop clamp only when the project already uses that mobile-shell pattern.

## 6. Lazy / Deferred (do NOT read at boot)
- `codex-router/codex-manifest.json` (228KB, path+hash integrity index, no descriptions) — use only to confirm a file exists / detect drift; never full-read at boot.
- Stubs `00_CODEX_CUSTOM_INSTRUCTIONS_CODEX_BRIDGE.md`, `CODEX_FULL_ACCESS_ROUTING.md` — superseded by PULSE; skip.
- Tier-0 deep reads (`GROUND_KERNEL.md` full P0–P19, `KARPATHY_TIER0_PRINCIPLES.md`, `PREFLIGHT_CHECKLIST.md`) — only on architecture/governance/recovery/high-risk turns.
- `00_CODEX_START_HERE.md` — full canonical boot reference; read only if PULSE is insufficient.
- Historical rollouts/artifacts — only when explicitly needed.

## 7. Reasoning Profile (compact)
Routine: Goal-contract + assumption-tag + token-discipline + verified-output (+ drift-guard if long). Medium: add evidence-ladder, hypothesis-test, risk+rollback. Deep/high-risk (`deep/thorough/review`): all 11 (+ counterexample check). Full set: `00_REASONING_EVOLUTION_PROTOCOL.md`.
- **Drift Guard**: every 3–5 tool batches re-read the anchor (originating request); classify on-track/minor/major; revert on major.
- **Output length**: hydration = 1 line · routine = outcome + 1 validation line · summary ≤100 words · architecture ≤250 words. No filler.
- **Comparison tables (MANDATORY)**: any comparison/before-after table MUST include token cost, speed, % speed increase, rating 1/10. Estimate + flag if exact unknown; never drop a column.

## 8. After editing `.codex`
Route integrity is mandatory: before merging, archiving, renaming, or deleting any knowledge/skill file or folder, find every route/reference to the old path, patch them to the new target or leave a redirect stub, then verify no active route breaks.

Regenerate routing: `codex-router/Update-CodexRouting.ps1 -Quiet` (if shell allows), then audit with `codex-router/Audit-CodexRouting.ps1`. If shell cannot run, update affected index entries manually and read back the changed routes.

---
**PULSE V1.0 — single boot read. Detailed canon: `00_CODEX_START_HERE.md` + `0_apex/GROUND_KERNEL.md`.**
