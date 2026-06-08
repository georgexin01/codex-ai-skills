# SINGLE TRUTH SOURCE PROTOCOL
**Type: AI Behavior Rule — MANDATORY**

---

## The Rule

**Every piece of data, logic, or config must live in exactly ONE place.**  
Everything else points to it. Nothing copies it.

---

## Forms of Single Truth

| Type | Single Source | Wrong Pattern |
|---|---|---|
| API endpoint URL | `config.ts` or `.env` | Hardcoded in 3 components |
| User role check | `useAuth()` composable | `if (user.role === 'admin')` repeated everywhere |
| Price format | `formatMYR()` C unit | `RM ${price.toFixed(2)}` in 10 places |
| DB table name | migration file | String literal in 5 queries |
| Color/spacing | design token / CSS var | Hardcoded `#FF5733` in 8 files |

---

## AI Enforcement

When AI writes code that would duplicate existing logic:
1. **STOP** — identify where the truth source is
2. **POINT** — import/reference it instead of copying
3. **EXTRACT** — if no truth source exists yet, create one first, then reference it

---

## Why This Is High-Value

- One bug fix → fixes everywhere automatically
- One config change → propagates everywhere
- AI edits are safer — change 1 file, not 10
- Reduces "I fixed it here but forgot over there" class of bugs

---

## Self-Check

- [ ] Is this value/logic defined somewhere else already?
- [ ] Am I about to write the same logic a second time?
- [ ] Should this be extracted into a shared C unit before I proceed?
