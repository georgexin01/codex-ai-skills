---
name: gitnexus
description: "GitNexus — installed MCP code knowledge-graph engine. Real-tool workflow (replaces the legacy GITNEXUS_* phantom docs)."
triggers: ["gitnexus", "knowledge graph", "blast radius", "impact analysis", "code structure"]
phase: governance
model_hint: ["claude-code", "codex-gpt-5.3"]
version: 1.0
status: active
date_updated: "2026-05-29"
supersedes: ["gitnexus-protocol", "gitnexus-deep-reasoning", "gitnexus-mcp-protocol", "gitnexus-design-protocol", "gitnexus-restrictions"]
---

# GitNexus

Real, installed open-source tool (`abhigyanpatwari/GitNexus`, npm `gitnexus`). Builds a queryable knowledge graph of a codebase — dependencies, call chains, imports, blast radius — and exposes it to the agent via MCP. Replaces the legacy `GITNEXUS_*` docs, which described a phantom `npx gitnexus` workflow that did not match the real tool.

## Status on this machine
- Installed globally: **gitnexus v1.6.4** (`npm i -g gitnexus`).
- Wired into Codex: `config.toml` → `[mcp_servers.gitnexus]` → `gitnexus.cmd mcp`.
- Capabilities (`gitnexus doctor`): graph store + full-text search available; VECTOR index unavailable on Windows → semantic search falls back to exact-scan (works, just not vector-accelerated).

## Workflow
1. **Index a repo**: run `gitnexus analyze` inside the git repo (`--force` for a full re-index). Creates a `.gitnexus/` folder for that repo.
2. **Use it**: restart Codex so the MCP server picks up the indexed repo. The agent then has graph tools — impact/blast-radius queries, dependency lookups, call-chain tracing, process-grouped search — answered in one call instead of many greps.
3. **Maintain**: re-run `gitnexus analyze` after significant changes; `gitnexus status` shows index freshness; `gitnexus clean` removes a repo's index.

## Key commands
| Command | Purpose |
|---|---|
| `gitnexus analyze [path]` | Index a repository |
| `gitnexus status` | Index freshness for current repo |
| `gitnexus list` | All indexed repos |
| `gitnexus mcp` | MCP server (stdio) — Codex spawns this |
| `gitnexus doctor` | Runtime capabilities |
| `gitnexus clean` | Remove current repo's index |

## When to use
Use for **impact-aware planning** (APEX 18 in GROUND_KERNEL): before editing a function/module in a real codebase, query the graph for dependents instead of guessing. Best on medium-to-large projects; small/self-contained tasks do not need it.

## Project allowlist (user policy, 2026-05-29)

GitNexus is **not the default**. Apply this allowlist before running `gitnexus analyze`:

| Project shape | Default |
|---|---|
| `vben admin` / `admin-panel-quizLaa` and similar large Vben + Supabase admins (thousands of files, many cross-module call chains) | **AUTO-INDEX ONCE IF NEW** — dramatic token savings vs. greping the tree |
| Other large real codebases (~1000+ code files with deep call chains) | Allowed after user confirms |
| Websites (PHP / static / marketing sites — e.g. `angel-interior-website`, `EcoWorld`) | **NOT USED** — grep is faster, indexing wastes ~50s + ~100 MB |
| Mobile apps / small PWAs / single-page apps | **NOT USED** — same reason |
| `.codex` knowledge / markdown trees | **NEVER** — not code |

Operational rules:
- Auto-run `gitnexus analyze` once for new large Vben/Supabase admin projects when `.gitnexus/` is missing.
- Re-run `gitnexus analyze` after long, structural, or schema-wide updates when impact analysis is likely to save time.
- Do **not** auto-run `gitnexus analyze` on PHP/static/marketing websites, small PWAs, mobile apps, or `.codex` itself. Confirm explicitly first for any non-allowlisted codebase.
- If a non-allowlisted project already has a `.gitnexus/` folder, it's stale opt-in from earlier — surface that fact and ask whether to keep or `gitnexus clean` it.
- `vben admin` projects are the canonical token-saving case (large schema + many BasicTable/Pinia/relation traversals); reach for the graph there before grep.

## Detect-and-Use Workflow

If a project has `.gitnexus/` in its root, the user has already opted in — use the MCP tools instead of grepping blind. If a new project is clearly a large Vben/Supabase admin, auto-index once; otherwise, fall back to grep/glob/read unless the user confirms.

| Task you would normally grep for | Use this MCP tool instead |
|---|---|
| "What calls this function / what breaks if I change it?" | `impact` — returns dependents grouped by depth + confidence in one call |
| "Where is this symbol used / what does it touch?" | `context` — 360° categorized references + process participation |
| "Find code related to this concept/feature" | `query` — hybrid BM25 + semantic search, grouped by execution flow |
| "What does my current git diff affect?" | `detect_changes` — maps changed lines to affected processes + risk |
| "Rename X across the repo safely" | `rename` — graph + text coordinated multi-file rename |
| "Custom graph traversal" | `cypher` — raw Cypher queries (needs schema knowledge) |

**Rules of use:**
- Check `.gitnexus/` exists before relying on the graph; if missing, auto-index only for a new large Vben/Supabase admin, otherwise fall back silently to grep/glob/read.
- On `gitnexus status` = stale (post-commit/merge): note it once if it's relevant to the task and proceed; the user reindexes when ready.
- For non-git projects, staleness can't be detected — assume the graph is fresh unless the user says otherwise.
- The graph indexes code, not markdown — for `.codex` knowledge routing, stay on `codex-manifest.json`.

## When to index

Run `gitnexus analyze` only when the project warrants it:

| Project shape | Action |
|---|---|
| New large Vben/Supabase admin with missing `.gitnexus/` | Auto-index once: `gitnexus analyze` (`--skip-git` if not a git repo) |
| Other real codebase: ~1000+ code files, real cross-module call chains | Ask, then index if confirmed |
| Already indexed, `gitnexus status` says stale after long/structural updates | Re-run `gitnexus analyze` |
| Thin site / static HTML-CSS / under ~50 code files (e.g. angel-interior-website) | Skip — grep is faster, indexing wastes ~50s + ~100 MB. Also covered by the project allowlist above. |
| `.codex` itself | Never — it is markdown knowledge, not code |

Notes:
- Non-git projects: staleness is not auto-detected and the PostToolUse hook will not fire — reindex manually after significant changes.
- `.gitnexus/` runs ~100-150 MB per indexed repo; gitignored and portable, but factor it into disk use before indexing many projects.

## Boundaries
- GitNexus indexes **code**, not `.codex` knowledge/skills markdown — it does not replace the codex-router (`codex-manifest.json` / `CODEX_DYNAMIC_ROUTING.md`), which routes knowledge files.
- The graph is per-repo and optional. Its absence degrades gracefully — never block a turn waiting on it.
- Governance constraints that the old `GITNEXUS_RESTRICTIONS.yaml` carried (no blind edits, no automatic renames, blast-radius before Tier-0/1 edits, Pros/Cons matrix) are already enforced by `GROUND_KERNEL.md` principles 0, 16, 18 and the edit-safety tiers — not duplicated here.
