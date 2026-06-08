# CONTRACT-FIRST PROTOCOL
**Type: AI Behavior Rule — MANDATORY**

---

## The Rule

**Define the contract (inputs + outputs + shape) BEFORE writing the implementation.**

A contract is a function signature + type + intent statement. Writing it first forces clarity and prevents scope creep mid-function.

---

## What a Contract Looks Like

```ts
// CONTRACT
// Input:  order { items[], userId, promoCode? }
// Output: { total: number, discounted: number, breakdown: LineItem[] }
// Rules:  promoCode is optional; total is never negative
function calculateOrderTotal(order: Order): OrderTotal { ... }
```

Even for JS (no types), write the comment contract first:
```js
// Input:  phone string (raw, any format)
// Output: string (E.164 format) or null if invalid
function normalizePhone(phone) { ... }
```

---

## Why AI Must Do This

1. **Catches scope creep** — if the contract is clear, adding "just one more thing" is obviously a violation
2. **Enables C-unit composition** — contracts are the connectors between C units; they must match
3. **Prevents hallucination** — AI that defines outputs before writing is less likely to drift
4. **Makes review instant** — reader knows what to expect before reading implementation

---

## Contract-First Flow

```
1. User asks for feature
2. AI writes contracts for all C units needed (signatures only)
3. User can verify the shape makes sense
4. AI fills in implementations
```

This gives user a checkpoint BEFORE code is written — catch design mistakes early, not after 100 lines.

---

## Mandatory For

- Any new composable / hook
- Any new API call function
- Any Pinia action
- Any PHP service method
- Any function >10 lines

---

## Self-Check

- [ ] Did I define input + output shape before writing the body?
- [ ] Does the function name match what the contract says it does?
- [ ] Would another AI be able to implement this from the contract alone?
