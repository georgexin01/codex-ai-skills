# Codex Start Here

This is the fastest startup router for Codex on this machine.

## Priority

1. Codex system, developer, tool, safety, sandbox, and current user instructions.
2. Current project instructions: `AGENTS.md`, `BLUEPRINT.md` (project-level, optional), and local task files.
3. Codex root bridge files in `C:\Users\User\.codex`.
4. Codex knowledge/memories/skills reference files.

## Ultra-Lean Knowledge Boot Sequence

Default profile: `Ultra-Lean`. **Primary boot = `00_PULSE.md` only.**

1. Read **`C:\Users\User\.codex\00_PULSE.md`** — the single boot read. It embeds the hot rules, the full trigger map, and the compact reasoning profile, and marks everything else lazy/deferred.
2. Resolve the trigger from PULSE and load only the matched file. Stop after first valid route match.
3. Everything below is **deferred** — load only when PULSE is insufficient (deep/governance/recovery/high-risk turns):
   - `C:\Users\User\.codex\CODEX_DYNAMIC_ROUTING.md` (current index map; regenerate via `Update-CodexRouting.ps1 -Quiet` if stale)
   - `C:\Users\User\.codex\00_CODEX_START_HERE.md` (this file — full canonical boot reference)
   - `C:\Users\User\.codex\00_REASONING_EVOLUTION_PROTOCOL.md` (full 12-rule reasoning protocol)
4. Superseded in boot (do not read — PULSE replaces them): `00_CODEX_CUSTOM_INSTRUCTIONS_CODEX_BRIDGE.md`, `CODEX_FULL_ACCESS_ROUTING.md` (both are redirect stubs).
5. `codex-router\codex-manifest.json` is a path/hash integrity index (no descriptions) — confirm existence / detect drift only; never full-read at boot.

## Tier-0 Deferred Deep Read

Load Tier-0 files only when the task is architecture/governance/recovery-sensitive, high-risk, or explicitly requests deep policy context:

1. `C:\Users\User\.codex\memories\0_apex\GROUND_KERNEL.md` (consolidated Tier-0 kernel: APEX principles + execution loop + operational standard + edit-safety tiers)
2. `C:\Users\User\.codex\memories\0_apex\KARPATHY_TIER0_PRINCIPLES.md` (constitutional behavior rules for coding and review quality)
3. `C:\Users\User\.codex\memories\2_governance\PREFLIGHT_CHECKLIST.md`

These are absolute principles/rules for behavior and execution style and are deferred for routine tasks to reduce token usage.

## Fast Read Order

1. `C:\Users\User\.codex\00_PULSE.md`
2. If PULSE is insufficient, run `C:\Users\User\.codex\codex-router\Update-CodexRouting.ps1 -Quiet` when shell/approvals allow.
3. `C:\Users\User\.codex\CODEX_DYNAMIC_ROUTING.md`
4. `C:\Users\User\.codex\00_CODEX_START_HERE.md`
5. `C:\Users\User\.codex\00_REASONING_EVOLUTION_PROTOCOL.md`
6. If route is unclear, fall back to:
   - `C:\Users\User\.codex\memories\2_governance\artifacts\skill_path_router.md`

## Token-Saving Runtime Policy

- Default response style is concise. Expand only when the user asks for more detail or risk requires it.
- Start with targeted reads (`rg`, specific files) and avoid broad tree scans unless blocked.
- Batch parallel file reads once and avoid repeated re-reads unless files changed.
- Keep default reasoning low; escalate reasoning only for complex/high-risk tasks or explicit user request.
- Run memory lookup only when the task clearly depends on prior decisions/workspace history.

## Reasoning Evolution Layer

- PULSE carries the compact startup reasoning profile; load and apply `C:\Users\User\.codex\00_REASONING_EVOLUTION_PROTOCOL.md` only when the deferred full protocol is needed.
- For routine tasks, apply compact reasoning rules with low overhead.
- For deep/high-risk tasks, apply full protocol including counterexample check and rollback-aware output.

## Hybrid Format Read Rules

- Treat `.md` as narrative and directives.
- Treat `.yaml` as high-density rules/config references.
- Treat `.json` as state/index metadata.
- Read top sections/keys first and stop early when route/intent is resolved.
- Avoid full-file hydration unless required for the active task.

## First-Pass Guardrails

- Do not recurse full trees under `memories`, `skills`, or `libraries` in first pass.
- Do not read historical rollouts/artifacts unless explicitly needed.
- Keep Tier-0 deferred unless deep, high-risk, governance, or recovery context is required.
- Normalize paths to `C:\Users\User\.codex` in runtime checks and use fallback resolution when manifest paths are stale.

## Auto-Escalation Triggers

- Escalate to Deep Capability Lane for: multi-file refactors, architecture/governance, security-sensitive changes, unknown-root-cause debugging, or explicit "deep/thorough/review" asks.
- Stay in Lean Fast Lane for routine/self-contained tasks.

## Trigger Phrases

- `ai read .codex knowledge` → route-first selective-load once per chat, cache compact context, then reply only `[🟢] Agent is Ready..`
- `ai read .codex skills` → `C:\Users\User\.codex\skills` (see `skill_path_router.md` for full index)
- `ai claude` → `C:\Users\User\.codex\skills\claude\WORKING_PROGRESS.md` (Vben Admin module builder — linear executor)
- `ai claude app` → `C:\Users\User\.codex\skills\claude-app\WORKING_PROGRESS.md` (mobile app Vue builder — linear executor)
- `ai claude website` → `C:\Users\User\.codex\skills\claude-website\WORKING_PROGRESS.md` (PHP + Supabase REST builder — linear executor)
- DB handshake shared by the 3 builders above → `C:\Users\User\.codex\skills\SHARED_DB_CONTRACT.md`
- `ai claude meta` → `C:\Users\User\.codex\skills\claude-meta\SKILL.md`
- `ai design app` → `C:\Users\User\.codex\skills\design\app\SKILL.md`
- `ai design website` → `C:\Users\User\.codex\skills\design\website\SKILL.md`
- `ai design spec` → `C:\Users\User\.codex\skills\design\_spec\SKILL.md` (DESIGN.md contract/lint)
- `ai karpathy` → `C:\Users\User\.codex\skills\karpathy-guidelines\SKILL.md`
- `ai imagegen` → `C:\Users\User\.codex\skills\imagegen\SKILL.md`
- `ai notebooklm <url|id>` → create `memories/2_governance/bridges/notebooklm_path_bridge.md` on first use

## Loading Rule

Do not read full trees. Load router/index files, then only task-relevant files.

## Main Sources

- Knowledge/memories: `C:\Users\User\.codex\memories`
- Skills: `C:\Users\User\.codex\skills`

## Practical Loading

- Route through indexes first.
- Read only required files.
- Prefer current project files over historical memory when conflicts exist.

## Safety

- Do not read or expose secrets/auth/token/cookie/session files unless explicitly requested and safe.
- Load only relevant files for the task; do not bulk-hydrate entire trees.
- If optional skill folders are missing, continue with native fallback workflows instead of failing.

## Format & Index Discipline (Primary Rule)

Goal: cut token waste, raise speed, and avoid reading whole files.

- **Index-first read**: resolve intent from router/manifest entries (`description` + `triggers`) before opening any file. Open a file only when the task actually needs its body. Never hydrate full trees.
- **Mandatory frontmatter**: every knowledge/skill file MUST carry a tight `description:` (one specific line) and `triggers:`. The index exposes these so the agent routes without reading the file.
- **Format-match the content** when creating or rewriting knowledge:
  - `.md` — narrative, directives, skills (humans edit these). Token-heaviest; use only where prose is needed.
  - `.yaml` — rules, principles, config, checklists, frontmatter. ~30% denser than equivalent MD prose; still readable.
  - `.json` — state, manifests, indexes. Machine state — queried, not read.
  - `.toon` — large repetitive/tabular data (file lists, route tables). Most compact.
- **Stop early**: read top sections/keys first; stop as soon as route/intent is resolved.
- Reference: `memories/0_apex/HYBRID_FORMAT_PROTOCOL.md`.
