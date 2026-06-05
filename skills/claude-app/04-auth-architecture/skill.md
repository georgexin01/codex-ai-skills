---
name: frontend-04-auth-architecture
description: "Step 04 — Supabase Auth with project-context switching: login flow with JWT-claim verification, fetchUser with double-binding check (public.user + quizLaa.users), logout with global store reset, $reset contract."
triggers: ["auth architecture", "supabase auth", "login flow", "jwt claims", "fetch user", "project binding", "resetAllStores"]
phase: 1-foundation
requires: [frontend-02-config-hardening, frontend-05-types-foundry]
unlocks: [frontend-06-industrial-stores, frontend-10-routing-logic]
output_format: typescript
version: 2.0
status: authoritative
last_updated: "2026-04-20"
---

# Step 04 — Auth Architecture

## 🎯 When to Use
After `src/config/` (Step 02) and `src/types/` (Step 05) exist. The auth store is the first real Pinia store in the app — it's treated as foundation because every subsequent data store calls `useAuthStore().user.id` for identity filtering.

## ⚠️ Dependencies
- **02-config-hardening** — `supabase` + `publicClient` + `env` exports
- **05-types-foundry** — `UserProfile`, `LoginParams` types

## 📋 Procedure

1. **Create `src/utils/pinia-reset.ts`** — global `resetAllStores()` helper (Code Vault §1). Needed by logout.
2. **Create `src/stores/auth.ts`** — Options-API Bakery store (Code Vault §2). MUST be Options API, not setup — cross-store ref unwrapping fails with setup syntax in Pinia 3.
3. **Create `src/stores/index.ts`** (barrel) — re-export all stores (Code Vault §3). Keep this in sync as new stores are added in Step 06.
4. **Register the store guard** in `src/router/index.ts` — the beforeEach snippet (Code Vault §4). Full router lives in Step 10; just add the guard now so login/logout redirects work.
5. **Verify project binding** — login as a seeded user, check console logs for `[Auth] Identity context successfully refreshed` and `[Auth] Business profile loaded successfully`.

## 📦 Code Vault

### §1. `src/utils/pinia-reset.ts`
```ts
import { getActivePinia } from 'pinia';

/**
 * Reset every active Pinia store.
 * Each store MUST implement its own `$reset()` action (Options API
 * does not provide a reliable default for all state shapes).
 */
export function resetAllStores() {
  const pinia: any = getActivePinia();
  pinia?._s?.forEach((store: any) => store.$reset?.());
}
```

### §2. `src/stores/auth.ts`
```ts
import { defineStore } from 'pinia';

import router from '@/router';
import { env, publicClient, supabase } from '@/config';
import type { LoginParams, UserProfile } from '@/types';
import { resetAllStores } from '@/utils/pinia-reset';

// ─── Helpers ─────────────────────────────────────────────

/** Decode a JWT payload and return the requested claim (if any). */
function getJwtClaim(token: string, claim: string): string | undefined {
  try {
    const parts = token.split('.');
    const encoded = parts[1] ?? '';
    const payload = JSON.parse(atob(encoded));
    return payload[claim];
  } catch {
    return undefined;
  }
}

// ─── Store (Bakery Pattern: Options API) ─────────────────

export const useAuthStore = defineStore('auth', {
  state: () => ({
    user: null as UserProfile | null,
  }),
  getters: {
    isLoggedIn: (state) => state.user !== null,
  },
  actions: {
    /**
     * Double-binding identity verification:
     *   1) public.user       — project binding (multi-project auth bridge)
     *   2) quizLaa.users     — business profile
     *   3) aggregate stats   — parallel count queries
     */
    async fetchUser(authId?: string, email?: string) {
      try {
        // 0. Self-hydrate if caller omitted args (session already active)
        if (!authId || !email) {
          const { data: sessionData } = await supabase.auth.getSession();
          const session = sessionData.session;
          if (!session) return;
          authId = session.user.id;
          email = session.user.email;
        }

        // 1. Project binding check (public schema via publicClient)
        const { data: publicUser, error: publicError } = await publicClient
          .from('user')
          .select('project_id')
          .eq('auth_id', authId)
          .eq('is_delete', false)
          .single();

        if (publicError || !publicUser) {
          throw new Error('Account project binding not found. Contact admin.');
        }
        if (publicUser.project_id !== env.PROJECT_ID) {
          throw new Error(
            'Unauthorized project access. Your account belongs to a different project.',
          );
        }

        // 2. Business profile (quizLaa schema via supabase client)
        const { data: userData, error: businessError } = await supabase
          .from('users')
          .select('*')
          .eq('email', email)
          .eq('isDelete', false)
          .single();

        if (businessError || !userData) {
          throw new Error('Business profile not found.');
        }

        // 3. Dashboard aggregate stats (parallel-safe — no auth dependency between them)
        const [totalRes, passedRes] = await Promise.all([
          supabase
            .from('user_lessons')
            .select('id', { count: 'exact', head: true })
            .eq('userId', userData.id)
            .eq('isDelete', false),
          supabase
            .from('questionAnswers')
            .select('lessonId')
            .eq('userId', userData.id)
            .gte('score', 80)
            .eq('isDelete', false),
        ]);

        const totalModules = totalRes.count || 0;
        const completedModules = new Set(
          (passedRes.data || []).map((r: any) => r.lessonId),
        ).size;

        // Map DB fields → UserProfile (UI shape)
        this.user = {
          agentId: `${userData.id.slice(0, 5)}...${userData.id.slice(-3)}`,
          rawId: userData.id,
          avatar:
            userData.avatar ||
            `https://ui-avatars.com/api/?name=${encodeURIComponent(userData.name)}&background=d52b1e&color=fff`,
          completedModules,
          email: userData.email || '',
          id: userData.id,
          monthlyProgress:
            totalModules > 0
              ? Math.round((completedModules / totalModules) * 100)
              : 0,
          name: userData.name || 'Student',
          nameEn: userData.name || '',
          remainingHours: 0,
          roles: [userData.role || 'student'],
          title:
            userData.role === 'admin'
              ? 'Administrator'
              : 'Senior Protocol Officer',
          titleEn: userData.role === 'admin' ? 'Administrator' : 'Senior Agent',
          totalModules,
        };
      } catch (error: any) {
        console.error('[Auth] Verification failure:', error.message);
        throw error;
      }
    },

    /**
     * Login: signInWithPassword → (if needed) switch project context →
     * hydrate business profile → persist token → route to /courses.
     */
    async login(params: LoginParams) {
      const { email, password } = params;

      // 1. Sign in
      const { data: authData, error: authError } =
        await supabase.auth.signInWithPassword({ email, password });
      if (authError) throw authError;
      if (!authData.user || !authData.session) {
        throw new Error('Login failed: no user data');
      }

      // 2. Project context switch — MANDATORY when JWT project_id != env.PROJECT_ID
      const jwtProjectId = getJwtClaim(
        authData.session.access_token,
        'project_id',
      );
      if (jwtProjectId !== env.PROJECT_ID) {
        await supabase.auth.updateUser({
          data: { active_project_id: env.PROJECT_ID },
        });
        const { data: refreshData, error: refreshError } =
          await supabase.auth.refreshSession();
        if (refreshError || !refreshData.session) {
          throw new Error('Identity verification failed during context switch.');
        }
      }

      // 3. Hydrate + persist + route
      await this.fetchUser(authData.user.id, email);
      localStorage.setItem('accessToken', authData.session.access_token);
      router.push('/courses');
    },

    async logout() {
      await supabase.auth.signOut();
      localStorage.removeItem('accessToken');
      this.user = null;
      resetAllStores();              // ← MUST reset sibling stores, else stale data leaks
      router.push('/login');
    },

    $reset() {
      this.user = null;
    },
  },
});
```

### §3. `src/stores/index.ts` (barrel)
```ts
export { useAuthStore } from './auth';
// Add more stores here as Step 06 produces them:
// export { useLessonsStore } from './lessons';
// export { useQuestionsStore } from './questions';
// ...
```

### §4. Router guard (partial — `src/router/index.ts`)
```ts
// Add this beforeEach guard. Full router is built in Step 10.
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
```

> ⚠️ This guard checks **token presence only** — not JWT expiry. Real auth validation happens when a store query returns 401 (expired token). That's acceptable for this stack because Supabase JS refreshes tokens client-side; a stale token will be traded for a fresh one before any RLS-gated read.

## 🛡️ Guardrails

- **Rule #1 (schema isolation)** — `publicClient` is used ONLY for `public.user.project_id` verification. Every business read goes through `supabase` (bound to quizLaa).
- **CONFIG FUNNEL** — auth reads `env.PROJECT_ID` from `@/config`, never `import.meta.env.VITE_PROJECT_ID` directly.
- **SESSION REFRESH AFTER updateUser** — if you switch project context and skip `refreshSession()`, the JWT stays stale and all subsequent RLS filters fail silently.
- **Options API only** — Pinia `defineStore('auth', { state, getters, actions })`. Do NOT use setup syntax here; cross-store ref access (e.g., from `lessons.ts` calling `useAuthStore().user`) unwraps inconsistently.
- **Every store MUST have `$reset()`** — Options API does not auto-provide it for nested state. Without it, `resetAllStores()` in logout is a no-op for that store and stale user data leaks into the next session.
- **Double-binding required** — `public.user` confirms *which project*; `quizLaa.users` delivers *the business profile*. Skipping either is a security hole.
- **Never store the password** — Supabase Auth handles hashing. `LoginParams` is read-and-forget.

## ✅ Verify

```bash
# 1. Boot dev server
pnpm dev

# 2. Sanity — login with a seeded user
#    (webApp-LAA-quiz-v2 seeds: agent1@quizlaa.com / 123456)
#    Expected console output:
#    [Auth] Identity context successfully refreshed.  (if project switch happened)
#    Redirect to /courses → page renders.

# 3. Stale-data test — logout, login as different user
#    Expected: ZERO cross-user data visible. If old user's dashboard stats
#    persist for a frame → resetAllStores() is broken or a store missed $reset.
```

Open Vue devtools → Pinia → `auth` store. After login, `user.id`, `user.email`, `user.rawId` are populated. After logout, `user` is `null` AND every other store's state is back to initial.

## ♻️ Rollback

```bash
rm -f src/stores/auth.ts src/utils/pinia-reset.ts
# Revert router guard block in src/router/index.ts
```

Supabase Auth rows are NOT deleted by the frontend — auth.users stays intact. Only the client-side session state is wiped.

## → Next Step
**[05-types-foundry](../05-types-foundry/skill.md)** — if not already done in parallel, create `src/types/` so `UserProfile`/`LoginParams` imports resolve.
Then **[06-industrial-stores](../06-industrial-stores/skill.md)** — data stores that depend on `useAuthStore().user.id`.
