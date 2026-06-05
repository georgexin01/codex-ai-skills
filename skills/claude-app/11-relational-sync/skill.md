---
name: frontend-11-relational-sync
description: "Step 11 — Relational Sync: webApp read-side protocol for admin-managed M2M tables. Assignment filter, intersection gates, soft-delete tolerance, history hydration."
triggers: ["relational sync", "webapp new table", "webapp sync admin", "assignment filter checklist", "m2m junction", "intersection filter"]
phase: 2-scaffold
requires: [frontend-06-industrial-stores]
unlocks: [frontend-09-view-scaffolding]
output_format: checklist
version: 2.0
status: authoritative
last_updated: "2026-04-20"
---

# Step 11 — Relational Sync (M2M read-side protocol)

## 🎯 When to Use
When an admin panel manages an M2M junction (e.g., `quizLaa.user_lessons`: which lessons are assigned to which agent) and the webApp must honor that assignment. Apply this checklist whenever a new relational table lands on the admin side.

This step is a **protocol + checklist**, not a big code dump — the actual code patterns live in Step 06 (intersection, fail-closed getDetail). Use this step as the sync contract.

## ⚠️ Dependencies
- **06-industrial-stores** — intersection pattern (Code Vault §2 of that step) is the reference implementation.

## 📋 Procedure (5-phase checklist)

### Phase 1 — Read-side type/store
- [ ] Add `src/types/<entity>.ts` with ONLY the fields the UI needs (minimal projection — don't mirror the whole admin DB).
- [ ] Add `src/stores/<entity>.ts` with read-focused actions: `getByUser(userId)`, `getByParent(parentId)`. Never `create`/`update`/`delete` — those belong to the admin side.
- [ ] Fail-closed: on missing user context → return empty arrays, never throw.

### Phase 2 — Visibility gates
- [ ] List/home page queries by the **relation key** (e.g., `.eq('userId', authStore.user.id)` on the junction table).
- [ ] Detail / video / quiz routes MUST guard direct URL access via a relation-existence check (see Code Vault §2 below).
- [ ] If the relation check fails → `router.replace('/courses')` (or the nearest safe list view). Never show "not assigned" error text to the user — just redirect.

### Phase 3 — Intersection pattern
- [ ] Build intersection set from:
  - Assigned entity IDs (from the junction table)
  - Entities that are valid for display (e.g., non-deleted, has ≥1 child like questions)
- [ ] Display ONLY the intersection output.
- [ ] If intersection is empty → empty state. Never fall back to "show all" — that breaks the assignment contract.

### Phase 4 — History & analytics
- [ ] History hydration must tolerate soft-deleted source entities (the quiz the student took 3 months ago may have been deleted since).
- [ ] Prefer JSONB snapshots (Step 06 §5) over live JOINs for historical data.
- [ ] Avoid exposing unassigned parent data in history views — if the user's assignment was revoked, the historical record stays (data integrity) but related actions (retake) gate the same way as live routes.

### Phase 5 — Verification
- [ ] User with N assignments sees exactly N items (minus any with zero children).
- [ ] User with zero assignments sees the empty state — not a generic error, not a "contact admin" alert, just clean empty state with an icon.
- [ ] Direct URL to unassigned detail / video / quiz → blocked and redirected (test by typing a known-valid-but-unassigned UUID into the address bar).
- [ ] Revoking an assignment in the admin → refresh → the course disappears from the list without the webApp crashing.

## 📦 Code Vault

### §1. Assignment store (minimal — `src/stores/user-lessons.ts`)
```ts
import { defineStore } from 'pinia';
import { supabase } from '@/config';
import type { UserLesson } from '@/types';

export const useUserLessonsStore = defineStore('user-lessons', {
  state: () => ({ assignments: [] as UserLesson[] }),
  actions: {
    async getByUser(userId: string): Promise<UserLesson[]> {
      if (!userId) { this.assignments = []; return []; }
      try {
        const { data, error } = await supabase
          .from('user_lessons')
          .select('id, userId, lessonId, assignDate, isDelete')
          .eq('userId', userId)
          .eq('isDelete', false);
        if (error) throw error;
        this.assignments = (data || []) as UserLesson[];
        return this.assignments;
      } catch (err) {
        console.error('[user-lessons] getByUser failed:', err);
        this.assignments = [];
        return [];
      }
    },
    $reset() { this.assignments = []; },
  },
});
```

### §2. Detail guard (inside a store — blocks direct URL)
```ts
async getDetail(id: string, userId?: string): Promise<Course | null> {
  if (!userId) return null;

  // 1) Assignment guard — user must be assigned
  const { data: assign } = await supabase
    .from('user_lessons')
    .select('id')
    .eq('userId', userId)
    .eq('lessonId', id)
    .eq('isDelete', false)
    .limit(1);
  if (!assign?.length) return null;

  // 2) Validity guard — entity must exist + have ≥1 child
  // ... (full code in Step 06 Code Vault §2)
}
```

### §3. View-level redirect (inside `onMounted`)
```ts
onMounted(async () => {
  await authStore.fetchUser();
  if (!authStore.user?.id) return router.replace('/login');

  const course = await lessonsStore.getDetail(route.params.id as string, authStore.user.id);
  if (!course) return router.replace('/courses');   // ← unassigned or missing → list
});
```

## 🛡️ Guardrails

- **Never fall back to "show all" when assignments are empty** — empty state must stay empty. Showing all lessons to an unassigned user defeats the assignment contract and leaks curriculum across projects.
- **Admin is the source of truth** — `quizLaa.user_lessons` is authored by the admin panel. WebApp is read-only for this table. Never INSERT/UPDATE/DELETE from the webApp side.
- **Relation checks before data reads** — assignment guard MUST run before the entity fetch. Reversing the order means you've already pulled data the user shouldn't see, even if the UI hides it.
- **Snapshot > live JOIN** for history — see Step 06 §5. Relational sync doesn't apply to historical data; snapshots decouple history from live assignment state.
- **Case convention** — junction tables are often snake_case (`user_lessons`) while some business tables are camelCase (`questionAnswers`). Don't normalize — match the actual schema.
- **Rule #1 (schema isolation)** — junction tables stay in `quizLaa.*`. Never FK out of the project schema.

## ✅ Verify (scripted test pattern)

```bash
# Test matrix — run through all 5 cases
# 1. User with N assignments + all have questions → N courses visible
# 2. User with N assignments + M have zero questions → (N-M) courses visible
# 3. User with zero assignments → empty state
# 4. Direct URL to unassigned UUID → redirect to /courses
# 5. Admin revokes an assignment mid-session → next list refresh drops it
```

## ♻️ Rollback
No rollback needed — this step is a protocol, not a file write. If a particular entity's sync is broken, fix the store (Step 06) for that entity.

## → Next Step
**[09-view-scaffolding](../09-view-scaffolding/skill.md)** — apply the view-level redirect pattern above when building list + detail pages.
**[13-native-pwa-deploy](../13-native-pwa-deploy/skill.md)** — once all entities sync correctly, ship it.
