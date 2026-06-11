# KNOWLEDGE_ROT_PROTOCOL.md - V1.1
# "Anti-Entropy Governance"

## 1. THE PROBLEM: KNOWLEDGE ROT
Knowledge rot occurs when documentation stays static while the codebase or environment evolves. This leads to "Hallucinations" where the AI relies on outdated ground truth.

## 2. AUTOMATED DETECTION (ROT-AUDIT)
Weekly, after a high-activity week, or on user request, the AI MUST execute a **ROT-AUDIT**:
1. **Timestamp Audit**: Flag any file in `0_apex`, `1_core`, or `2_governance` that has not been updated in >30 days.
2. **Path Audit**: Run `codex-router/Audit-CodexRouting.ps1` to detect missing entries and broken routing links.
3. **Symbol Drift**: Compare the `Entity Definitions` in `DNA_LOGIC.md` against the actual `types.ts` in the project. If they differ, trigger a **RESURRECTION TURN**.
4. **Runtime Noise Audit**: Prune safe transient folders/files (`.tmp`, cache, stale session indexes, large sqlite WAL/SHM noise) only when they are not active and the target path is verified.
5. **Route Integrity Audit**: Before any merge/archive/rename/delete, find references to the old path, patch active routes to the merged target or leave a redirect stub, then regenerate and audit routing.

## 3. MAINTENANCE MANDATE
- **YAML Frontmatter**: Every knowledge file MUST include a `last_audit` date.
- **Pruning**: If a file is flagged as "Irrelevant" during an audit, it MUST be moved to `vault/archive` instead of being deleted.

## 4. EXECUTION
AI can trigger a rot-check by saying: `ai run rot-audit` or `ai run weekly rot-audit`.
This executes:
- `codex-router/Update-CodexRouting.ps1 -Quiet` then `codex-router/Audit-CodexRouting.ps1`
- `Get-ChildItem -Recurse | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) }`
- A targeted old-boot-reference scan across active/deferred docs; patch only active/deferred contradictions and leave archive/rollout history untouched.
- For every changed route path: `rg "<old path or filename>" .` before and after the move/merge, proving all active references now point to the replacement.

## 5. MEMORY.MD AUTO-TRIM RULE

`memories/MEMORY.md` has a hard cap of **300 lines**.

- During every rot-audit (or any session that adds new task groups), count lines in `MEMORY.md`.
- If line count exceeds 300: remove the **oldest task groups from the bottom** until the file is ≤300 lines.
- The User Profile and Key Preferences section at the top is **never trimmed**.
- The governance comment on line 1 is **never removed**.
- After trimming, update the file in place — no archive needed for MEMORY.md trimmed content (task groups are already fully captured in rollout_summary files).

## 6. DEAD PROJECT TOMBSTONE RULE

Project-specific memory files that are no longer active are auto-moved to `memories/archive/` during rot-audit.

**Tombstone triggers (any one is sufficient):**
- Filename prefix matches a known dead project (e.g., `wrider_*`, or any file with `applies_to: cwd=` pointing to a path not recently active).
- File has not been referenced or updated in >30 days and has a project-specific name (not a governance/apex/cross-project file).

**Action:**
1. Move flagged files to `memories/archive/` (do NOT delete — per §3 Pruning rule).
2. Log the move: `[date] moved [filename] to archive — tombstone trigger: [reason]`.
3. Do not require user confirmation for tombstone moves; notify the user in one line after.

**Immediately tombstoned files (2026-05-21):**
- `wrider_complete_recipe.md` → `memories/archive/`
- `wrider_design_senses.md` → `memories/archive/`
- `wrider_chat_mining.md` → `memories/archive/`
