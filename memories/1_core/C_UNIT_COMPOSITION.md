# C-UNIT COMPOSITION PROTOCOL
**Type: AI Behavior Rule — MANDATORY**

---

## The Law

```
C = smallest possible unit of logic (1 job, no side effects)
C + C = composed function
C + C + C + C = feature / service
```

Every function written by AI must follow this shape. No monoliths. No big functions that could be split.

---

## Before Writing ANY Function — AI Must:

1. **SCAN first** — search existing codebase for C units that already do part of the job
2. **COMPOSE second** — if C units exist, combine them. Never duplicate.
3. **SPLIT third** — if writing new logic, decompose into smallest C units first, then compose up
4. **NEVER** write a function >30 lines without decomposing it into named C units

---

## What Makes a Valid C Unit

- Does exactly **1 job**
- Has a **clear, verb-noun name**: `formatPrice()`, `isLoggedIn()`, `fetchUser()`, `parseDate()`
- **No side effects** unless that is its sole job (e.g. `saveToStorage()`)
- **Returnable / testable** in isolation
- Max ~15-25 lines. If longer, split again.

---

## Anti-Patterns (AI Must Refuse These)

❌ `handleEverything()` — does 5 jobs  
❌ `utils.js` with 300 lines of unrelated helpers  
❌ Copying logic from one component to another instead of extracting a C unit  
❌ Writing a new function before checking if one already exists  

---

## Stack-Specific C Unit Forms

| Stack | C Unit Form | Example |
|---|---|---|
| JS / jQuery | Pure function | `formatMYR(amount)` |
| Vue 3 | Composable | `useAuth()`, `usePagination()` |
| Pinia | Action atom | `fetchUser()`, `clearSession()` |
| PHP | Static helper / single-method class | `PriceHelper::format()` |
| SQL | View or function | `get_active_users()` |

---

## Composition Pattern

```js
// ❌ Bad — one big function
function submitOrder(data) {
  // validate, format, save, notify — all in one
}

// ✅ Good — C units composed
function submitOrder(data) {
  const validated = validateOrder(data)       // C
  const formatted = formatOrderPayload(validated) // C
  const saved = await saveOrder(formatted)    // C
  await notifyUser(saved.id)                  // C
}
```

---

## AI Self-Check Before Committing Code

- [ ] Is every function doing exactly 1 job?
- [ ] Did I scan for existing C units before writing new ones?
- [ ] Can any function here be extracted and reused elsewhere?
- [ ] Is the composition readable — does the top-level function read like a sentence?
