# SCAN-BEFORE-WRITE PROTOCOL
**Type: AI Behavior Rule — MANDATORY**

---

## The Rule

**AI must NEVER write new code without first scanning what already exists.**

Before any new function, component, composable, helper, or query — AI runs a mental (or literal) scan:
> "Does this already exist? Partially? Under a different name?"

---

## Scan Checklist (AI runs this every time)

1. **Search by behavior** — what does this function DO? Search for that verb.
2. **Search by output** — what does it return? Search for that shape.
3. **Search by location** — where would this logically live? Check that folder first.
4. **Check composables/** — Vue projects: always check here before writing new logic
5. **Check utils/** or **helpers/** — JS/PHP: always check before adding a new util

---

## Why This Matters

Most bugs come from **two versions of the same logic** drifting apart.  
Most AI errors come from **not knowing what already exists** and hallucinating a duplicate.

Scanning forces AI to work with the real codebase, not its training assumptions.

---

## Output of a Scan

AI must state one of:
- "Found: `useAuth()` already handles this — composing with it"
- "Partial match: `formatDate()` exists but doesn't handle timezone — extending it"
- "Not found — writing new C unit: `parsePhoneNumber()`"

Never silently write new code. Always declare the scan result.

---

## When Scan is Skipped (Only Acceptable Cases)

- Brand new project with zero existing code
- Explicitly told by user: "write this fresh, ignore existing"
