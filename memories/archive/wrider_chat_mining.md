---
name: wrider-chat-mining
description: "Auto-evolution protocol — how to mine the user's iterative edits and feedback into updates of wrider_design_senses.md and BLUEPRINT.md. Run at the end of every long session."
triggers: ["wrider", "chat mining", "design retrospective", "design senses update", "design audit"]
phase: 0-orchestrator
version: 1.0.0
status: authoritative
date_authored: "2026-05-05"
project: "c:/Users/user/Desktop/wRider"
companion: "./wrider_design_senses.md"
---

# 🔁 wRider — Chat Mining & Design Auto-Evolution Protocol

> **Purpose**: keep [`wrider_design_senses.md`](./wrider_design_senses.md)
> alive without the user having to re-explain preferences.
> Whenever you wrap up a long working session on this project, run this
> protocol so the next AI starts smarter than this one did.

---

## 🪤 When to mine

**Trigger conditions** — run the protocol when ANY of these hold:

1. **End-of-session**: the user wraps up with an acknowledgment ("ok", "thanks", "all good", silence after a successful build).
2. **Pattern saturation**: the user has corrected the same kind of edit ≥ 2 times in this session (e.g. dropped `font-black` to `font-bold` in three different files).
3. **Explicit invocation**: the user says "update design senses", "update knowledge", "remember this", "keep evolving".
4. **Conflict surface**: a system-reminder shows the user undid an edit you just made — the original instinct was wrong, document the correction.

---

## 🔬 What to extract

For every user-driven change observed in the session (search the transcript
for "Note: <file> was modified", "user changed", "user said", and your own
edits the user re-did), capture:

| Field | What goes here |
|---|---|
| **Trigger** | The user's verbatim phrase or the diff that signalled the preference. |
| **Surface** | Concrete element / file affected (`WRHeader.vue:26`, `.wr-balance` weight). |
| **From → To** | Old value vs. new value, both quoted exactly. |
| **Inferred reason** | One sentence — e.g. "DM Sans 900 felt aggressive at large sizes". |
| **Generalised rule** | The principle this maps to — e.g. "Display numbers cap at 700–800 in DM Sans". |
| **Map to SENSE #** | Which existing SENSE (1–15) in `wrider_design_senses.md` this belongs to. |
| **Action** | `update-existing` (append to a SENSE) / `add-new-sense` (drop a new SENSE block) / `add-forbidden` (extend the FORBIDDEN list) / `update-blueprint` (touch BLUEPRINT.md typography or visual-token table). |

---

## 🪄 How to update

### Path A — append to an existing SENSE

If the change reinforces an existing principle, **append a row** to the
SENSE's example/migration table and (if applicable) widen the rule's
"reserved for" or "forbidden" list.

Example: user dropped `text-base font-black` → `text-base font-bold` in a
new file. SENSE 1's migration table grows by one row; nothing else changes.

### Path B — add a new SENSE

Only if no existing SENSE covers it. Use SENSE 16, 17, … and write:

```markdown
## 🎯 SENSE {N} — {one-sentence rule}

**The rule:** {concrete imperative}

**Observed migration:** {minimal example with file paths}

**Forbidden:** {what NOT to do}
```

Ten new SENSEs in one session means you're bucketing too narrowly —
collapse first.

### Path C — touch BLUEPRINT.md

When the change affects the architectural manifest (new component
contract, new route bucket, new design token), edit
[`BLUEPRINT.md`](../../../Desktop/wRider/BLUEPRINT.md) in addition to the
senses file. Keep the senses file as the *aesthetic* reference and the
blueprint as the *architectural* reference.

### Path D — leave a "stale" annotation

If a SENSE is contradicted but you're not 100 % sure of the new direction,
mark it:

```markdown
> ⚠️ **STALE since 2026-05-12** — user has been overriding rule #7 in
> recent sessions. Need at least 2 more reinforcing edits before
> rewriting.
```

Don't silently rewrite a senses entry on a single contrary signal.

---

## 📋 Session retrospective template

Paste this at the end of any long wRider session and fill it in **before**
editing the knowledge files. Keeps your reasoning auditable.

```markdown
### Retrospective — {session date / topic}

**Edits I made that the user kept**: {N}
**Edits I made that the user re-did**: {N}
**Re-do patterns**:
  - {pattern 1, e.g. "kept lowering font weights"}
  - {pattern 2}

**New SENSEs to add**: {N or "none"}
**SENSEs to extend**: {list, e.g. "SENSE 1, SENSE 5"}
**SENSEs to mark stale**: {list or "none"}
**Blueprint touches**: {description or "none"}

**One-line takeaway for next session**: {sentence}
```

---

## 🛡️ Guardrails

1. **Never modify BLUEPRINT.md or `wrider_design_senses.md` based on a
   single, ambiguous signal.** Two reinforcing observations or one explicit
   user statement minimum.
2. **Never delete a SENSE** without leaving a `> ⚠️ DEPRECATED 2026-XX-XX`
   header — the project's design history is itself part of the knowledge.
3. **Never rename a SENSE number** — they're referenced by other tools and
   the user. Add new ones at the end.
4. **Never replace user phrasing in the "Trigger" column** — direct quotes
   keep the lineage clear.
5. **Never document preferences inferred from your own taste** — only
   document what the user explicitly directed or repeatedly corrected.

---

## 🔗 Companion files

- [`wrider_design_senses.md`](./wrider_design_senses.md) — the senses doc
  this protocol maintains.
- [`../../Desktop/wRider/BLUEPRINT.md`](../../../Desktop/wRider/BLUEPRINT.md)
  — architectural manifest (typography, tokens, layout, routes).
- The user's CLAUDE.md says `.gemini/antigravity/knowledge/` is always
  readable — this means the senses file is in scope every conversation.
  No special invocation needed to *read* it. *Writing* requires explicit
  user permission ("update design senses", "remember this", etc.).

---

**Authored:** 2026-05-05 · v1.0.0
