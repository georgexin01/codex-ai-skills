---
name: frontend-06-industrial-stores
description: "Step 06 — src/stores/: Options-API Bakery Pattern. Fail-closed, identity-filtered, $reset-capable Pinia stores. MOST critical folder — every business function lives here."
triggers: ["industrial stores", "pinia store", "bakery pattern", "options api store", "fail closed", "dbToApp", "generate store"]
phase: 2-scaffold
requires: [frontend-04-auth-architecture, frontend-05-types-foundry]
unlocks: [frontend-09-view-scaffolding, frontend-11-relational-sync]
output_format: typescript
version: 2.0
status: authoritative
last_updated: "2026-04-20"
---

# Step 06 — Industrial Stores (the `src/stores/` pillar — most important)

## 🎯 When to Use
After auth (Step 04) + types (Step 05). This is where **every business function lives**. Views call store actions; they never touch `supabase` directly.

The user explicitly flagged this folder as the most important: "stores folder for pinia store to load and use this is most important folder all function mostly located here."

## ⚠️ Dependencies
- **04-auth-architecture** — every store filters by `useAuthStore().user.id` (fail-closed).
- **05-types-foundry** — every store imports `<DBEntity>` + `<Entity>` from `@/types`.

## 📋 Procedure

1. **For each entity**, create `src/stores/<entity>.ts` — Options API, Bakery Pattern (Code Vault §1 template).
2. **Define the `dbToApp` transform** inline (or in a helper file) — DB shape → App shape.
3. **Implement fail-closed actions**:
   - `getList(userId?)` → if `!userId` return `[]`, never re-throw.
   - `getDetail(id, userId?)` → if unassigned or missing, return `null`.
   - Soft-delete filter `.eq('isDelete', false)` on every query.
4. **Implement `$reset()`** — required. `resetAllStores()` calls it on logout. Without it, stale data leaks across sessions.
5. **Update `src/stores/index.ts`** — re-export the new store.
6. **For parent→child intersection queries** (e.g., lessons that are both assigned AND non-empty), use the two-query pattern in Code Vault §2 (DO NOT use PostgREST embedded selects on local Docker — see Guardrails).

## 📦 Code Vault

### §1. Store Template (Bakery Pattern — copy & rename)
```ts
import { defineStore } from 'pinia';

import { supabase } from '@/config';
import type { <Entity>, DB<Entity> } from '@/types';

// ─── DB → App Transform ──────────────────────────────────

function dbTo<Entity>(row: DB<Entity>): <Entity> {
  return {
    id: row.id,
    // Map DB fields → UI fields here.
    // e.g.: title: row.title, duration: `${row.duration} min`, ...
  };
}

// ─── Store (Bakery Pattern: Options API) ─────────────────

export const use<Entity>Store = defineStore('<entity>', {
  state: () => ({
    items: [] as <Entity>[],
    current: null as <Entity> | null,
  }),
  actions: {
    /** Fail-closed list fetch — empty when unauthed. */
    async getList(userId?: string): Promise<<Entity>[]> {
      if (!userId) {
        this.items = [];
        return [];
      }
      try {
        const { data, error } = await supabase
          .from('<table>')
          .select('*')
          .eq('userId', userId)
          .eq('isDelete', false);
        if (error) throw error;
        this.items = (data || []).map(dbTo<Entity>);
        return this.items;
      } catch (err) {
        console.error('[<Entity>] getList failed:', err);
        this.items = [];
        return [];
      }
    },

    /** Fail-closed detail fetch — null when unauthed or unassigned. */
    async getDetail(id: string, userId?: string): Promise<<Entity> | null> {
      if (!userId) return null;
      const cached = this.items.find((i) => i.id === id);
      if (cached) {
        this.current = cached;
        return cached;
      }
      try {
        const { data, error } = await supabase
          .from('<table>')
          .select('*')
          .eq('id', id)
          .eq('isDelete', false)
          .single();
        if (error || !data) return null;
        this.current = dbTo<Entity>(data);
        return this.current;
      } catch (err) {
        console.error('[<Entity>] getDetail failed:', err);
        return null;
      }
    },

    $reset() {
      this.items = [];
      this.current = null;
    },
  },
});
```

### §2. Reference: `src/stores/lessons.ts` (intersection filter — full production code)
```ts
import { defineStore } from 'pinia';

import { supabase } from '@/config';
import type { Course, Lesson } from '@/types';

function dbToCourse(item: Lesson, questionsCount: number, bestScore: number = 0): Course {
  return {
    bestScore,
    description: item.description || '',
    duration: `${item.duration || 0} min`,
    id: item.id,
    image:
      Array.isArray(item.images) && item.images.length > 0
        ? item.images[0]!
        : '',
    isPassed: bestScore >= 80,
    questionsCount,
    sort: item.sort || 0,
    tag: 'Beginner',
    title: item.title || '',
  };
}

export const useLessonsStore = defineStore('lessons', {
  state: () => ({
    courses: [] as Course[],
    currentCourse: null as Course | null,
  }),
  actions: {
    /**
     * Fetch lessons that are BOTH (a) assigned to this user AND
     * (b) have at least one non-deleted question. Fail-closed.
     */
    async getList(userId?: string): Promise<Course[]> {
      if (!userId) { this.courses = []; return []; }

      try {
        // Query A — lessonIds with ≥1 question (+ count per lesson)
        const { data: qRows, error: qErr } = await supabase
          .from('questions')
          .select('lessonId')
          .eq('isDelete', false);
        if (qErr) throw qErr;

        const countMap: Record<string, number> = {};
        (qRows || []).forEach((q: any) => {
          if (q.lessonId) countMap[q.lessonId] = (countMap[q.lessonId] || 0) + 1;
        });
        const withQuestions = new Set(Object.keys(countMap));

        // Query B — lessonIds assigned to this user (de-dupe via Set)
        const { data: assignRows, error: aErr } = await supabase
          .from('user_lessons')
          .select('lessonId')
          .eq('userId', userId)
          .eq('isDelete', false);
        if (aErr) throw aErr;

        const assigned = new Set(
          (assignRows || []).map((r: any) => r.lessonId).filter(Boolean),
        );

        // Intersect — only lessons that are BOTH assigned AND non-empty
        const allowedIds = [...assigned].filter((id) => withQuestions.has(id));
        if (allowedIds.length === 0) { this.courses = []; return []; }

        // Parallel: C — lesson rows;  D — user best-score per lesson
        const [lessonsRes, scoresRes] = await Promise.all([
          supabase
            .from('lessons')
            .select('*')
            .eq('isDelete', false)
            .in('id', allowedIds)
            .order('sort', { ascending: true }),
          supabase
            .from('questionAnswers')
            .select('lessonId, score')
            .eq('userId', userId)
            .eq('isDelete', false),
        ]);
        if (lessonsRes.error) throw lessonsRes.error;

        const scoreMap: Record<string, number> = {};
        (scoresRes.data || []).forEach((r: any) => {
          const s = typeof r.score === 'number' ? r.score : parseFloat(String(r.score));
          if (!scoreMap[r.lessonId] || s > scoreMap[r.lessonId]) scoreMap[r.lessonId] = s;
        });

        this.courses = ((lessonsRes.data as Lesson[]) || []).map((l) =>
          dbToCourse(l, countMap[l.id] || 0, scoreMap[l.id] || 0),
        );
        return this.courses;
      } catch (err) {
        console.error('Failed to fetch lessons:', err);
        this.courses = [];
        return [];
      }
    },

    /** Fail-closed detail — cache-first, blocks unassigned direct URLs. */
    async getDetail(id: string, userId?: string): Promise<Course | null> {
      if (!userId) return null;

      const cached = this.courses.find((c) => c.id === id);
      if (cached) { this.currentCourse = cached; return cached; }

      try {
        // Assignment guard — blocks direct URL to unassigned lesson
        const { data: assign } = await supabase
          .from('user_lessons')
          .select('id')
          .eq('userId', userId)
          .eq('lessonId', id)
          .eq('isDelete', false)
          .limit(1);
        if (!assign?.length) return null;

        const [lessonRes, qCountRes] = await Promise.all([
          supabase.from('lessons').select('*').eq('id', id).eq('isDelete', false).single(),
          supabase.from('questions').select('id', { count: 'exact', head: true })
            .eq('lessonId', id).eq('isDelete', false),
        ]);
        if (lessonRes.error || !lessonRes.data) return null;
        if ((qCountRes.count ?? 0) === 0) return null;

        const { data: scoreRes } = await supabase
          .from('questionAnswers')
          .select('score')
          .eq('userId', userId).eq('lessonId', id).eq('isDelete', false)
          .order('score', { ascending: false })
          .limit(1);
        const bestScore = scoreRes?.[0]?.score || 0;

        const course = dbToCourse(
          lessonRes.data as Lesson,
          qCountRes.count ?? 0,
          typeof bestScore === 'number' ? bestScore : parseFloat(String(bestScore)),
        );
        this.currentCourse = course;
        return course;
      } catch (err) {
        console.error('Failed to fetch lesson detail:', err);
        return null;
      }
    },

    $reset() {
      this.courses = [];
      this.currentCourse = null;
    },
  },
});
```

### §3. Minimal Example — `src/stores/user-lessons.ts` (M2M projection)
```ts
import { defineStore } from 'pinia';

import { supabase } from '@/config';
import type { UserLesson } from '@/types';

export const useUserLessonsStore = defineStore('user-lessons', {
  state: () => ({
    assignments: [] as UserLesson[],
  }),
  actions: {
    async getByUser(userId: string): Promise<UserLesson[]> {
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
        console.error('Failed to fetch user lesson assignments:', err);
        this.assignments = [];
        return [];
      }
    },

    $reset() { this.assignments = []; },
  },
});
```

### §4. Store Barrel — `src/stores/index.ts`
```ts
export { useAuthStore } from './auth';
export { useLessonsStore } from './lessons';
export { useQuestionsStore } from './questions';
export { useQuestionAnswersStore } from './question-answers';
export { useUserLessonsStore } from './user-lessons';
export { useUiStore } from './ui';
// New stores go here. Keep the export list alphabetical.
```

### §5. Snapshot Persistence (for mutable source rows)
```ts
// For quiz attempts / orders / anything where source rows may mutate later,
// store a JSONB snapshot — do NOT rehydrate from live tables.

interface AnswerSnapshot {
  questionId: string;
  options: string[];       // post-shuffle order the user actually saw
  correctKey: string;      // 'A' | 'B' | 'C' | 'D'
  selectedKey: string;
}

// On submit:
await supabase.from('questionAnswers').insert({
  userId,
  lessonId,
  answers: attempt.snapshots,              // JSONB column holds AnswerSnapshot[]
  score: attempt.score,
  submittedAt: new Date().toISOString(),
  isDelete: false,
});

// On review: hydrate directly from row.answers — no JOIN needed.
```

## 🛡️ Guardrails

- **Rule #1 (schema isolation)** — every `.from()` targets a `quizLaa.*` table. Cross-schema reads go via `publicClient` (bound to `public`) and ONLY for `auth.users` / `public.user` / `public.project`.
- **Options API only** — `defineStore('name', { state, actions, getters })`. Setup syntax `defineStore('name', () => { ... })` breaks cross-store ref unwrapping in Pinia 3 when accessed from another store.
- **Fail-closed is the law** — no `userId` → return `[]` or `null`. Never throw from `getList`. A thrown error in a list view = user-visible crash. Swallow → empty state → fail-closed UI.
- **Soft-delete always** — `.eq('isDelete', false)` on every fetch of a quizLaa table. Missing it leaks deleted rows.
- **Casing (critical)** — `quizLaa.*` columns are camelCase: `isDelete`, `userId`, `lessonId`, `createdAt`. `public.*` columns are snake_case: `is_delete`, `auth_id`, `project_id`. Mixing them = silent empty response.
- **No embedded selects on local Docker** — `.select('*, parent(name)')` fails with PGRST200 because the local Docker Supabase has a flaky FK schema cache. Use two-query join + `Map` lookup (see §2 Query A/B/C pattern).
- **Two-query rule for intersections** — lessons-with-questions-AND-assigned-to-user requires intersecting two Sets. Don't try to do it in one PostgREST query.
- **`$reset()` is required** — no exceptions. `resetAllStores()` iterates `pinia._s` and calls `store.$reset?.()`. Store without `$reset` = no-op for that store = stale data leak on logout.
- **Snapshot, don't rehydrate** — for quiz answers, order items, or anything where source rows may change after capture, persist a JSONB snapshot. Rehydrating from live tables gives wrong history if someone edits the source.
- **Views never touch `supabase`** — if a view imports `supabase` from `@/config`, that's a red flag. Every DB read goes through a store action.
- **No `import.meta.env` in stores** — use `env.*` from `@/config`. This is the CONFIG FUNNEL rule from Step 02.

## ✅ Verify

```bash
pnpm type-check
# Expected: exit 0. TS catches missing $reset, wrong column names (if types are strict).

grep -rn "import.meta.env" src/stores/     # expect: empty
grep -rn "setup" src/stores/               # audit for accidental setup-style stores

# Runtime:
# 1. Login → /courses → list renders.
# 2. Navigate to /courses/<unassigned-uuid>  → redirect back to /courses.
# 3. Logout → re-login as different user → ZERO stale courses from previous user.
```

## ♻️ Rollback
```bash
rm -rf src/stores/<entity>.ts        # or the whole src/stores/ folder
# Views that consume the store will error loudly — fix them up the chain.
```

## → Next Step
**[07-image-spec](../07-image-spec/skill.md)** — storage upload + `<AppImage>` fallback.
Parallel: **[09-view-scaffolding](../09-view-scaffolding/skill.md)** can start consuming these stores.
See also: **[11-relational-sync](../11-relational-sync/skill.md)** for deeper M2M patterns.
