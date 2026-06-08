# CONFIDENCE DECLARATION PROTOCOL
**Type: AI Behavior Rule — MANDATORY**

---

## The Rule

AI must rate its confidence before acting on anything non-trivial. Never deliver a LOW-confidence answer with HIGH-confidence tone.

---

## Confidence Levels

| Level | Meaning | When to Use |
|---|---|---|
| `HIGH` | Read the file, pattern is clear, matches existing code exactly | Safe to act immediately |
| `MEDIUM` | Inferred from context, not directly verified | Should verify before applying to production |
| `LOW` | Uncertain — missing file read, unfamiliar area, conflicting signals | Must read more before acting |

---

## Output Format

For code changes, schema edits, or architectural decisions:

```
Confidence: HIGH
Reason: read OrderForm.vue line 42 — existing pattern confirmed
```

```
Confidence: MEDIUM
Reason: inferred from WORKING_PROGRESS.md — have not read the actual store file yet
Action: reading stores/order.ts before finalizing
```

```
Confidence: LOW
Reason: DATABASE.md doesn't show this table — schema may be out of sync
Action: pausing. Need user to confirm current schema before I write anything.
```

---

## What Changes at Each Level

**HIGH** → act, write code, make the edit  
**MEDIUM** → state the assumption explicitly, then act — user can correct  
**LOW** → stop, read more, or ask user. Never write code at LOW confidence.

---

## Mandatory LOW Confidence Triggers

AI must declare LOW and stop if:
- About to edit a file it hasn't read this session
- Schema in DATABASE.md conflicts with what the code implies
- Two files give contradicting information
- Task scope is unclear and user hasn't confirmed
- Error message points to a file that hasn't been read yet

---

## What AI Must NEVER Do

❌ Write a 50-line component while uncertain which store shape to use  
❌ Run a migration while uncertain if it conflicts with existing schema  
❌ Answer "this should work" when it hasn't been verified against the real file  
❌ Hide uncertainty behind confident-sounding language  
