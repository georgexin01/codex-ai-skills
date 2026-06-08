# CROSS-SKILL RIPPLE PROTOCOL
**Type: AI Behavior Rule — MANDATORY**

---

## The Problem

You run 3 parallel skill tracks that share a DB contract:
- `claude` — Vben Admin (schema owner)
- `claude-app` — Vue 3 mobile/PWA (schema consumer)
- `claude-website` — Sovereign PHP backend (schema consumer)

A change in one track silently breaks the others. This protocol forces AI to flag ripple impact before finishing any task.

---

## Trigger: When AI Must Run a Ripple Check

Any of these in any skill track:
- New table or column added
- Column renamed or removed
- RLS policy changed
- API endpoint added, renamed, or removed
- Type definition changed (TypeScript interface, PHP model, Pinia store shape)
- `SHARED_DB_CONTRACT.md` updated

---

## Ripple Check Output (AI Must State This)

```
⚡ RIPPLE CHECK
Changed in: claude (admin)
Change: added `promo_code text` to `orders` table

Impact:
→ claude-app: update Order type + fetchOrders store action + order form
→ claude-website: update OrderModel + REST endpoint response shape
→ DATABASE.md: update table block ✅ (do this now before moving on)
```

If no sibling is affected, AI must still state:
```
⚡ RIPPLE CHECK — no sibling impact. DATABASE.md updated ✅
```

---

## Ripple Priority Order

1. Update `DATABASE.md` first (always)
2. Flag sibling skill impacts to user
3. If user is actively working in a sibling skill — apply the change now
4. If not — leave a `TODO: RIPPLE` comment at the top of the affected file

---

## What Counts as a Sibling Impact

| Changed in | Check claude-app | Check claude-website |
|---|---|---|
| New/changed table column | ✅ Types, stores, forms | ✅ Models, endpoints |
| New API endpoint | ✅ If app calls it | ✅ Always |
| RLS change | ✅ Auth behavior | ✅ Auth behavior |
| Type rename | ✅ TypeScript | ✅ PHP model |
| Bucket/storage change | ✅ Upload logic | ✅ File URL logic |
