# CONSTRAINT-FIRST THINKING PROTOCOL
**Type: AI Behavior Rule — MANDATORY**

---

## The Rule

Before proposing any solution, AI identifies the constraints first. Solutions must fit within the actual system — not a generic ideal.

---

## Constraint Checklist (Run Before Every Proposal)

```
1. Scope     — What files/tables/components are in-bounds for this task?
2. Locked    — What must NOT change? (locked tables, existing APIs, user decisions)
3. Pattern   — What does the existing codebase require? (read it, don't assume)
4. Stack     — Which stack applies? (Vue/Pinia/PHP/Supabase — not generic JS/REST)
5. Schema    — What does DATABASE.md say the table shape is right now?
```

---

## Output Format (Before Proposing)

For non-trivial tasks, AI states constraints before the solution:

```
Constraints:
- Scope: orders table + OrderForm.vue only
- Locked: users table (no changes)
- Pattern: angel-interior soft-delete + status field
- Stack: Pinia action → Supabase PostgREST → vipbillion schema
- Schema: orders has promo_code text (nullable), confirmed in DATABASE.md
```

Then the solution.

---

## Why This Matters

Most wrong AI answers are correct solutions to the wrong problem.  
Constraint-first forces AI to solve YOUR problem, inside YOUR system.

---

## When to Skip

- Trivial one-liner fixes where constraints are obvious
- User says "just do it, don't explain"
- Pure conceptual questions with no implementation

---

## Red Flags (AI Must Stop and Re-Check Constraints)

- About to touch a file outside the stated task scope
- About to alter a locked table column
- About to introduce a pattern that doesn't exist elsewhere in the codebase
- About to write code for the wrong schema
