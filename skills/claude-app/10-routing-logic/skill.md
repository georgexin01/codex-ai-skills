---
name: frontend-10-routing-logic
description: "Step 10 — src/router/: Vue Router with auth guard, lazy-loaded views, title injection, deep-link redirect. Full router for the quiz-style webApp."
triggers: ["routing logic", "vue router", "auth guard", "beforeeach", "router redirect", "meta.requiresAuth", "catchall route"]
phase: 3-ui
requires: [frontend-04-auth-architecture, frontend-09-view-scaffolding]
unlocks: [frontend-13-native-pwa-deploy]
output_format: typescript
version: 2.0
status: authoritative
last_updated: "2026-04-20"
---

# Step 10 — Routing Logic (the `src/router/` pillar)

## 🎯 When to Use
After views exist (Step 09) and auth store is in place (Step 04). The router ties them together.

## ⚠️ Dependencies
- **04-auth-architecture** — `localStorage.accessToken` + `resetAllStores()` wired.
- **09-view-scaffolding** — view components exist at `@/views/*`.

## 📋 Procedure

1. **Create `src/router/index.ts`** — use Code Vault §1 as the base. Every route declares `meta.requiresAuth` (true|false) and `meta.title`.
2. **Add a catch-all** — `/:pathMatch(.*)*` redirects to `/login`. This makes deep-link pokes go through the auth guard.
3. **Register the guard** — `router.beforeEach` checks token presence. Already covered in Step 04 Code Vault §4; full version here.
4. **Title injection** — `router.afterEach` sets `document.title`. Format: `"<route title> | <app title>"`.
5. **Lazy-load every view** — `() => import('@/views/...')`. Never eager-load — first-paint budget suffers.
6. **Main import** — in `src/main.ts` (already done in Step 01): `app.use(router)`.

## 📦 Code Vault

### §1. Full `src/router/index.ts` (quiz-style webapp)
```ts
import { createRouter, createWebHistory } from 'vue-router';

const router = createRouter({
  history: createWebHistory(),
  routes: [
    // ─── Public ──────────────────────────────────────────
    {
      path: '/login',
      name: 'Login',
      component: () => import('@/views/login/index.vue'),
      meta: { requiresAuth: false, title: 'Login' },
    },

    // ─── Authenticated ───────────────────────────────────
    {
      path: '/courses',
      name: 'CourseList',
      component: () => import('@/views/courses/list.vue'),
      meta: { requiresAuth: true, title: 'My Courses' },
    },
    {
      path: '/courses/:id',
      name: 'CourseDetail',
      component: () => import('@/views/courses/detail.vue'),
      meta: { requiresAuth: true, title: 'Course Details' },
    },
    {
      path: '/courses/:id/video',
      name: 'CourseVideo',
      component: () => import('@/views/courses/video.vue'),
      meta: { requiresAuth: true, title: 'Training Video' },
    },
    {
      path: '/courses/:id/quiz',
      name: 'Quiz',
      component: () => import('@/views/quiz/index.vue'),
      meta: { requiresAuth: true, title: 'Interactive Quiz' },
    },
    {
      path: '/quiz-result',
      name: 'QuizResult',
      component: () => import('@/views/quiz/result.vue'),
      meta: { requiresAuth: true, title: 'Quiz Results' },
    },
    {
      path: '/quiz-review',
      name: 'QuizReview',
      component: () => import('@/views/quiz/review.vue'),
      meta: { requiresAuth: true, title: 'Result Review' },
    },
    {
      path: '/history',
      name: 'History',
      component: () => import('@/views/history/index.vue'),
      meta: { requiresAuth: true, title: 'Attempt History' },
    },

    // ─── Default + Catch-all ─────────────────────────────
    { path: '/', redirect: '/courses' },
    { path: '/:pathMatch(.*)*', redirect: '/login' },
  ],
});

// ─── Auth Guard ──────────────────────────────────────────

router.beforeEach((to) => {
  const token = localStorage.getItem('accessToken');
  const isAuthenticated = !!token;

  if (to.meta.requiresAuth && !isAuthenticated) {
    return { name: 'Login' };
  }
  if (to.name === 'Login' && isAuthenticated) {
    return { name: 'CourseList' };
  }
  return true;
});

// ─── Title Injection ─────────────────────────────────────

router.afterEach((to) => {
  const baseTitle = 'LAA Training Quiz';      // swap per project
  document.title = to.meta.title
    ? `${to.meta.title as string} | ${baseTitle}`
    : baseTitle;
});

export default router;

/** Expose for apiClient.ts — useful when building shareable web links. */
export const isHashRouting = (): boolean => router.options.history.base.startsWith('#');
```

### §2. Generic route module template (for larger webapps)
```ts
// src/router/modules/<feature>.ts
import type { RouteRecordRaw } from 'vue-router';

const featureRoutes: RouteRecordRaw[] = [
  {
    path: '/<feature>',
    name: '<Feature>List',
    component: () => import('@/views/<feature>/list.vue'),
    meta: { requiresAuth: true, title: 'Feature List' },
  },
  {
    path: '/<feature>/:id',
    name: '<Feature>Detail',
    component: () => import('@/views/<feature>/detail.vue'),
    meta: { requiresAuth: true, title: 'Feature Detail' },
  },
];

export default featureRoutes;
```

### §3. Auto-register modules (for very large apps — like Vben admin)
```ts
// src/router/index.ts alternative — auto-glob modules
import { createRouter, createWebHistory } from 'vue-router';
import type { RouteRecordRaw } from 'vue-router';

const modules = import.meta.glob('./modules/*.ts', { eager: true });
const routes: RouteRecordRaw[] = [];
Object.values(modules).forEach((m: any) => {
  if (m.default) routes.push(...m.default);
});

const router = createRouter({
  history: createWebHistory(),
  routes: [
    { path: '/login', component: () => import('@/views/login/index.vue'),
      meta: { requiresAuth: false } },
    ...routes,
    { path: '/', redirect: '/courses' },
    { path: '/:pathMatch(.*)*', redirect: '/login' },
  ],
});

// Guards/title hooks same as §1.
export default router;
```

## 🛡️ Guardrails

- **Token-presence guard is weak but pragmatic** — the guard checks `localStorage.accessToken` truthiness, NOT JWT expiry. Supabase JS refreshes tokens client-side before each request, so a stale token is traded transparently. A truly expired-and-unrefreshable token will surface as a 401 from a store call → which should redirect to login (handle in store's error branch, not the guard).
- **Fail-closed in stores, not in router** — detail-route guarding (e.g., "is this lesson assigned to this user?") lives in the STORE's `getDetail()` + the VIEW's `if (!item) router.replace(...)` pattern. Do not try to do relation checks in `beforeEach` — it creates race conditions with data fetching.
- **Catch-all must redirect to `/login`** — not `/courses`. An unauthed poke at `/somewhere` should bounce to login, not silently redirect to a protected page (which then bounces again — double-redirect animation glitch).
- **Lazy-load every non-login route** — eager-loading all views balloons the initial JS bundle. First paint matters, especially on mobile.
- **History mode: `createWebHistory()`** — clean URLs. Hash routing (`createWebHashHistory()`) only when deploying to a host that can't rewrite (e.g., GitHub Pages). `isHashRouting()` helper above detects which is active.
- **Meta discipline** — every route declares `requiresAuth` + `title`. Missing either = guard logic has to special-case, which breeds bugs.
- **Route naming** — PascalCase for `name:` (`CourseList`, `QuizResult`). Used by `router.push({ name: '...' })` to avoid stringly-typed paths.
- **No direct `import.meta.env` in router** — follow CONFIG FUNNEL (Step 02). If you need env-gated routes (e.g., show `/debug` only in dev), read from `env.*` via `@/config`.

## ✅ Verify

```bash
# 1. Type-check — expect 0
pnpm type-check

# 2. Navigation tests
#    - Unauthed visit to /courses  → bounces to /login
#    - Authed visit to /login      → bounces to /courses
#    - Visit /does-not-exist        → bounces to /login (catch-all)
#    - Visit /                      → bounces to /courses (default)

# 3. Title injection
#    - /courses          → "My Courses | LAA Training Quiz"
#    - /courses/<uuid>   → "Course Details | LAA Training Quiz"

# 4. Lazy-load verification
#    Open DevTools Network tab → navigate to new route → a new JS chunk loads
#    on demand (not during initial page load).
```

## ♻️ Rollback
```bash
# Restore previous router from git, then:
# Views will 404 if they referenced route names that no longer exist.
```

## → Next Step
**[11-relational-sync](../11-relational-sync/skill.md)** — if this webApp syncs from an admin panel with M2M tables (user_lessons, etc.), apply the relational checklist.
Then **[13-native-pwa-deploy](../13-native-pwa-deploy/skill.md)** for production.
