# Codex Global Bridge

Personal Codex behavior contract for this machine. Paths are relative to the Codex home (`~/.codex/`). This file loads every session — canonical rule bodies live in the referenced files; this file points, it does not duplicate.

## Startup

- On a new task, read `00_PULSE.md` first (ultra-lean profile). Stop at the first valid route match; never scan full trees.
- Use `00_CODEX_START_HERE.md` only as the deferred canonical boot reference when PULSE is insufficient.
- Read PULSE once per chat session, then reuse the compact in-session context unless the user asks to refresh or risk escalates.
- `ai read .codex knowledge` runs route-first selective load once, stores compact in-session context, then returns only the ready sentinel.
- Apply `00_REASONING_EVOLUTION_PROTOCOL.md` as the default reasoning contract.
- Tier-0 files (`memories/0_apex/GROUND_KERNEL.md`, `memories/0_apex/KARPATHY_TIER0_PRINCIPLES.md`, `memories/2_governance/PREFLIGHT_CHECKLIST.md`) load only for architecture / governance / high-risk / recovery work — deferred for routine tasks.

## Behavior Contract

- **Highest-priority operating ladder**: safety/data sovereignty -> evidence/truth -> route-first context -> surgical edits -> verification -> user/project taste. If lower-level guidance conflicts, this ladder wins.
- **Plan-first**: clarify scope, define success criteria, then execute. Skip planning on a clear terse execute order ("run X", "fix this line").
- **Dual-lane**: Lean Fast Lane for routine/self-contained tasks; auto-escalate to Deep Capability Lane for multi-file refactors, architecture, security, unknown-root-cause debugging, or explicit "deep / thorough / review".
- **Karpathy Tier-0** (full body: `memories/0_apex/KARPATHY_TIER0_PRINCIPLES.md`): think before coding, simplest path, surgical scope, goal-driven. Run the internal 4-check review (Assumptions surfaced · Simplicity preserved · Surgical scope respected · Verification evidence) before every final answer; keep it hidden unless asked or a blocker is unresolved.
- **Evidence ladder**: file state > tests > logs > memory > inference. Never present inference as fact; say "INSUFFICIENT DATA" when ambiguous.
- **Verify before done**: smoke-test / lint / read-back every edit. Circuit breaker — after 3 failed fixes on the same issue, stop and switch to deep-audit.
- **Concise output**: hydration → 1 line; routine → outcome + 1 validation line; summary ≤100 words; architecture advice ≤250 words. No filler, no preamble.

## Engineering Defaults (Stack Rules)

Default stack: Vue 3 Composition API · TypeScript · Pinia · Tailwind · Vben Admin · Supabase/Postgres · PHP for websites.

- **Casing bridge**: DB = snake_case (`created_at`); frontend / Pinia / Vben forms = camelCase (`createdAt`). Map at every boundary. ID registry: `memories/1_core/VOCABULARY.md`.
- **Schema isolation**: business data lives in its own Postgres schema, never `public`. RLS helpers/RPCs are `SECURITY DEFINER` in `public`.
- **Store-only**: views never call the API client directly — always through Pinia stores (single source of truth). Wrap every API/DB call in try/catch; validate forms with Zod.
- **Multi-part work** (3+ changes, multiple files, or DB+code mixed): list numbered steps, do ONE step per response, end with "Step X done — confirm or adjust?", then wait. Single-line fixes skip this.
- **Supabase / SQL** (full protocol: `memories/2_governance/LAA_ECOSYSTEM_API_PROTOCOL.md`):
  - Apply SQL from a file (`docker cp` + `psql -f`), never inline `psql -c` — PowerShell strips quotes around camelCase identifiers.
  - A working INSERT needs BOTH an RLS policy AND a `permissions` row for that role.
  - Storage paths: no leading slash. On live-data tables, add a corrective numbered migration — never DROP+CREATE.
  - Vben forms must expose `formApi` in `defineExpose`, or drawers silently break.
- **Local dev servers**: keep the process alive (background process or a user-run launcher) — never foreground-then-exit. Verify with `curl` (expect HTTP 200) before claiming success.
  - PHP sites → `php -S 127.0.0.1:<port>` (front controller `index.php`; port 8000-8003, first free). Protocol: `memories/2_governance/LOCALHOST_PHP_TEST_PROTOCOL.md`.
  - Vben admin → `pnpm.cmd run dev:local` from the panel root (Windows-safe `.cmd`); Vite serves `localhost:6006`. Protocol: `memories/2_governance/VBEN_ADMIN_LOCAL_DEV_PROTOCOL.md`.
- **Design** (taste profile: `memories/0_apex/USER_DNA.md`): 700 weight default (900 only for numeric spectacle), 6px linear elements, violet/teal/dark + glow, glassmorphism overlays, sharp contrast — no gray-on-gray. Industrial density: raw tables, minimal card padding. Replace native `<select>` / file input / `confirm()` with design-system components.
- **Mobile / PWA**: viewport `width=device-width, initial-scale=1.0, viewport-fit=cover` — never hardcode pixel width or lock zoom. Thumb-zone CTAs, bottom-sheet modals, safe-area insets.
- Video fields are platform-agnostic — never hardcode "YouTube". Disable the Vben mock notification widget (`widget.notification: false`) unless a real feed is wired.

## GitNexus — Detect-and-Use (allowlisted, controlled auto-index)

- Use the graph if `.gitnexus/` already exists in the project root.
- Allowlist: Vben admin / large Supabase admin projects only. Skip for PHP sites, static/marketing pages, small PWAs — use grep/glob there.
- If present, prefer MCP tools over blind grep: `impact` (blast radius before editing), `context` (symbol 360°), `query` (concept search), `detect_changes` (pre-commit diff impact), `rename` (safe multi-file rename).
- Auto-run `gitnexus analyze` once for new large Vben/Supabase admin projects when `.gitnexus/` is missing; never run it on `.codex` itself.
- Re-run GitNexus after long or structurally different updates when the project has grown enough that impact analysis is likely useful.
- Workflow reference: `memories/2_governance/GITNEXUS.md`.

## Output Format

**Comparison tables (MANDATORY)** — for any "comparison table" or before/after request, include these rows in addition to topic columns:

| Metric | Before | After | Δ / Notes |
|---|---|---|---|
| Token cost | est. (~12k) | est. (~6k) | % drop |
| Speed | qualitative | qualitative | direction |
| Speed increase % | — | numeric (+~50%) | required |
| Rating | x/10 | y/10 | delta |

Estimate honestly when exact numbers aren't measurable; flag the estimate, never omit a column.

## Trigger Phrases & Mapping

- `knowledge` = `memories/`; `skills` = `skills/`.
- `ai read .codex knowledge` → route once, cache compact context, return only the ready sentinel.
- `ai read .codex skills` → load the matching skill route only.
- `ai claude` → `skills/claude`, `skills/claude-app`, `skills/claude-website`, `skills/claude-meta`.
- `ai design app` → `skills/design/app`; `ai design website` → `skills/design/website`.
- A prompt containing `notebooklm.google.com/notebook/` → auto-route `memories/2_governance/bridges/notebooklm_path_bridge.md`.

## Boundaries

- Load only necessary files; no full-tree hydration. Prefer current project files over old memory on conflict.
- Never expose secrets / auth / token / cookie / session files unless explicitly requested and safe.
- Knowledge freeze: no structural change to `memories/` or `skills/` without explicit turn-by-turn user approval. `AGENTS.md` / `00_*` / Tier-0 files = Plan-Stop-Approve before editing.
- Route integrity: before merging, archiving, renaming, or deleting any knowledge/skill path, update every active route/reference to the new path or leave a redirect stub, then regenerate and audit routing.
- If an optional skill folder is missing, degrade gracefully with native tools — never fail the turn.
- Keep ignore files (`.codexignore`, `.claudeignore`, `.geminiignore`, `.openaiignore`) aligned. Periodically prune runtime noise (`.tmp`, sessions, cache, large sqlite logs) when safe.
