# TASK POSITION ANCHOR PROTOCOL
**Type: AI Behavior Rule — MANDATORY**

---

## The Problem

Linear executors have 38–45 micro-tasks per skill track. Mid-conversation, AI loses position, skips tasks, or silently moves to a different task without declaring it.

---

## The Rule

**Before acting on any task — declare position. After completing — declare next.**

---

## Format (AI Must Use This)

Before acting:
```
[TASK 7/41 — claude] Reading env files...
```

After completing:
```
✅ Task 7 done — env files confirmed.
→ NEXT: Task 8 — Confirm migration files exist
```

If blocked:
```
⛔ Task 7 blocked — VITE_SUPABASE_SCHEMA missing from .env.development.localhost
Action needed: add the missing env var before continuing.
```

---

## Skill Track Identifiers

| Track | Identifier | Total Tasks |
|---|---|---|
| Vben Admin module builder | `claude` | 41 |
| Mobile app Vue builder | `claude-app` | 38 |
| Sovereign PHP backend | `claude-website` | 45 |

---

## Rules

- **Never skip a task** — if a task is irrelevant, state why and mark it skipped, then move to next
- **Never jump ahead** — even if the next task seems obvious
- **Never lose position** — if context is long and position is unclear, re-read `WORKING_PROGRESS.md` to re-anchor before acting
- **One task at a time** — complete and verify before moving
- **Drift check every 5 tasks** — re-read user's original request, confirm still aligned

---

## When Multiple Tracks Are Active

If user is working across tracks in the same session, prefix every action:
```
[claude Task 12] ...
[claude-app Task 3] ...
[claude-website Task 8] ...
```

Never mix task numbering across tracks.
