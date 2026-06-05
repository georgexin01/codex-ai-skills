---
name: frontend-09-view-scaffolding
description: "Step 09 — src/views/: List/Detail/Form view templates with loading skeleton, empty state, fail-closed guard, toast feedback. Consumes stores from Step 06, UI patterns from Step 08."
triggers: ["view scaffolding", "src/views", "generate view", "list view", "detail view", "form view", "page template"]
phase: 3-ui
requires: [frontend-06-industrial-stores, frontend-08-ui-standardization]
unlocks: [frontend-10-routing-logic]
output_format: vue_file
version: 2.0
status: authoritative
last_updated: "2026-04-20"
---

# Step 09 — View Scaffolding (the `src/views/` pillar)

## 🎯 When to Use
After stores (06) and UI conventions (08). Each feature gets a `src/views/<feature>/{list, detail, form}.vue` trio (or a single `index.vue` for standalone pages like login).

## ⚠️ Dependencies
- **06-industrial-stores** — stores provide fail-closed `getList` / `getDetail`.
- **08-ui-standardization** — shell, skeleton, empty state, script-block order.

## 📋 Procedure

1. **Create `src/views/<feature>/` folder**. Common files:
   - `list.vue` — paginated/grouped collection
   - `detail.vue` — single-record viewer (reads `route.params.id`)
   - `form.vue` — create/edit (optional, for self-service webApps)
   - `index.vue` — use when the feature is a single page (e.g., login)
2. **Follow the script block order** from Step 08 §4 (1.Imports · 2.Props · 3.Stores · 4.State · 5.Lifecycle · 6.Functions).
3. **Sequential `onMounted`** — `authStore.fetchUser()` → guard → `store.getList(user.id)`. Never `Promise.all` across auth + data boundaries.
4. **Fail-closed in views** — if `store.getDetail(...)` returns `null`, `router.replace(...)` to a safe parent route. Never show a "not found" error.
5. **Toast all feedback** — success + error, via `useUiStore().addToast()`.

## 📦 Code Vault

### §1. `list.vue` — data list with skeleton + empty state
```vue
<script setup lang="ts">
// 1. Imports
import { onMounted, ref } from 'vue';
import { useRouter } from 'vue-router';

import { useAuthStore, useLessonsStore, useQuestionAnswersStore } from '@/stores';
import type { Course } from '@/types';
import AppImage from '@/components/AppImage.vue';

// 3. Stores
const authStore = useAuthStore();
const lessonsStore = useLessonsStore();
const qaStore = useQuestionAnswersStore();
const router = useRouter();

// 4. Local State
const loading = ref<boolean>(true);
const todayStats = ref({
  quizzes: 0,
  lessons: 0,
  totalQuestions: 0,
  correctAnswers: 0,
  accuracy: 0,
});

// 5. Lifecycle
onMounted(async () => {
  loading.value = true;
  try {
    // Sequential: fetchUser MUST resolve before getList
    await authStore.fetchUser();
    if (!authStore.user?.id) {
      lessonsStore.courses = [];
      return;
    }
    await lessonsStore.getList(authStore.user.id);
    todayStats.value = await qaStore.fetchTodayStats(authStore.user.id);
  } catch (err: unknown) {
    const msg = err instanceof Error ? err.message : String(err);
    console.error('Failed to load courses:', msg);
  } finally {
    loading.value = false;
  }
});

// 6. Functions
function selectCourse(course: Course): void {
  lessonsStore.currentCourse = course;
  router.push(`/courses/${course.id}`);
}
</script>

<template>
  <div class="relative flex min-h-screen w-full flex-col overflow-x-hidden max-w-[480px] mx-auto bg-white dark:bg-background-dark">
    <!-- Header -->
    <header class="sticky top-0 z-50 flex items-center bg-white/80 dark:bg-background-dark/80 backdrop-blur-md p-4 pb-2 justify-between border-b border-gray-100 dark:border-gray-800">
      <div class="flex size-10 shrink-0 items-center"></div>
      <h2 class="text-gray-900 dark:text-white text-lg font-bold leading-tight tracking-tight flex-1 text-center">
        Course Selection
      </h2>
      <div class="flex w-10 items-center justify-end">
        <button @click="authStore.logout()" class="text-primary text-sm font-bold active:opacity-60">
          Logout
        </button>
      </div>
    </header>

    <main class="flex-1 overflow-y-auto pb-24">
      <!-- Loading skeleton -->
      <div v-if="loading" class="flex flex-col gap-4 p-4">
        <div v-for="i in 3" :key="i"
          class="animate-pulse flex items-stretch justify-between gap-4 rounded-xl bg-gray-50 dark:bg-gray-900/40 p-4 border border-gray-100 dark:border-gray-800">
          <div class="flex-1 space-y-3 py-1">
            <div class="h-2 bg-gray-200 rounded w-1/4"></div>
            <div class="h-4 bg-gray-200 rounded w-3/4"></div>
            <div class="h-2 bg-gray-200 rounded w-1/2"></div>
          </div>
          <div class="size-24 bg-gray-200 rounded-lg"></div>
        </div>
      </div>

      <!-- List -->
      <div v-else-if="lessonsStore.courses.length > 0" class="flex flex-col gap-4 p-4">
        <div
          v-for="course in lessonsStore.courses"
          :key="course.id"
          @click="selectCourse(course)"
          class="flex items-stretch justify-between gap-4 rounded-xl bg-white dark:bg-gray-900/40 p-4 ios-shadow border border-gray-100 dark:border-gray-800 cursor-pointer active:scale-95 transition-all"
        >
          <div class="flex flex-[2_2_0px] flex-col justify-between gap-3">
            <div class="flex flex-col gap-1">
              <p class="text-primary text-base font-bold leading-tight">{{ course.title }}</p>
              <p class="text-gray-500 dark:text-gray-400 text-xs line-clamp-1">{{ course.description }}</p>
            </div>
            <button class="flex min-w-[100px] max-w-[120px] items-center justify-center rounded-lg h-9 px-4 text-sm font-bold bg-primary text-white active:scale-95">
              Start
            </button>
          </div>
          <AppImage :src="course.image" alt="Course" custom-class="w-24 h-24 rounded-lg flex-shrink-0" />
        </div>
      </div>

      <!-- Empty -->
      <div v-else class="flex flex-col items-center justify-center py-20 px-10 text-center gap-4">
        <div class="size-20 rounded-full bg-gray-100 dark:bg-gray-800 flex items-center justify-center">
          <span class="material-symbols-outlined text-gray-400 text-4xl">inventory_2</span>
        </div>
        <div class="space-y-1">
          <p class="text-gray-900 dark:text-white font-bold text-lg">No courses available</p>
          <p class="text-gray-500 dark:text-gray-400 text-sm">Please check back later.</p>
        </div>
        <button @click="lessonsStore.getList(authStore.user?.id)" class="text-primary font-bold text-sm mt-2">
          Refresh
        </button>
      </div>
    </main>
  </div>
</template>
```

### §2. `detail.vue` — single record with fail-closed guard
```vue
<script setup lang="ts">
// 1. Imports
import { onMounted, ref } from 'vue';
import { useRoute, useRouter } from 'vue-router';

import { useAuthStore, useLessonsStore } from '@/stores';
import type { Course } from '@/types';
import AppImage from '@/components/AppImage.vue';

// 3. Stores
const authStore = useAuthStore();
const lessonsStore = useLessonsStore();
const route = useRoute();
const router = useRouter();

// 4. Local State
const course = ref<Course | null>(null);
const loading = ref<boolean>(true);

// 5. Lifecycle
onMounted(async () => {
  loading.value = true;
  try {
    await authStore.fetchUser();
    if (!authStore.user?.id) return router.replace('/login');

    const result = await lessonsStore.getDetail(
      route.params.id as string,
      authStore.user.id,
    );
    if (!result) {
      // Fail-closed: unassigned or missing → bounce to list
      return router.replace('/courses');
    }
    course.value = result;
  } finally {
    loading.value = false;
  }
});

// 6. Functions
function startQuiz(): void {
  if (!course.value) return;
  router.push(`/courses/${course.value.id}/quiz`);
}
</script>

<template>
  <div class="relative flex min-h-screen w-full flex-col max-w-[480px] mx-auto bg-white dark:bg-background-dark">
    <header class="sticky top-0 z-50 flex items-center bg-white/80 dark:bg-background-dark/80 backdrop-blur-md p-4 justify-between border-b border-gray-100 dark:border-gray-800">
      <button @click="router.back()" class="text-primary">
        <span class="material-symbols-outlined">arrow_back</span>
      </button>
      <h2 class="text-gray-900 dark:text-white text-lg font-bold flex-1 text-center">Course Details</h2>
      <div class="w-6"></div>
    </header>

    <main v-if="course" class="flex-1 overflow-y-auto pb-24 p-4">
      <AppImage :src="course.image" alt="Course cover" custom-class="w-full h-48 rounded-2xl mb-4" />
      <h1 class="text-2xl font-bold mb-2">{{ course.title }}</h1>
      <p class="text-gray-500 mb-4">{{ course.description }}</p>
      <p class="text-sm text-gray-400 mb-8">
        {{ course.duration }} · {{ course.questionsCount }} questions
      </p>
      <button
        @click="startQuiz"
        class="flex w-full items-center justify-center rounded-xl h-14 bg-primary text-white font-bold shadow-xl shadow-primary/30 active:scale-[0.98]"
      >
        Start Quiz
      </button>
    </main>

    <!-- loading skeleton optional -->
  </div>
</template>
```

### §3. `form.vue` (create/edit pattern — for self-service cases)
```vue
<script setup lang="ts">
// 1. Imports
import { ref } from 'vue';
import { useRouter } from 'vue-router';

import { useAuthStore, useUiStore, use<Entity>Store } from '@/stores';

// 3. Stores
const authStore = useAuthStore();
const uiStore = useUiStore();
const entityStore = use<Entity>Store();
const router = useRouter();

// 4. Local State
const loading = ref(false);
const form = ref({
  name: '',
  description: '',
});

// 6. Functions
async function handleSubmit(): Promise<void> {
  if (loading.value) return;
  if (!authStore.user?.id) return router.replace('/login');

  loading.value = true;
  try {
    await entityStore.create({
      ...form.value,
      userId: authStore.user.id,
      isDelete: false,
    });
    uiStore.addToast('Saved', 'Created successfully.', 'success');
    router.back();
  } catch (e: unknown) {
    const msg = e instanceof Error ? e.message : 'Save failed.';
    uiStore.addToast('Error', msg, 'error');
  } finally {
    loading.value = false;
  }
}
</script>
```

### §4. `useUiStore` — toasts + ambient UI state
```ts
// src/stores/ui.ts
import { defineStore } from 'pinia';

interface Toast {
  id: number;
  title: string;
  message: string;
  type: 'success' | 'error' | 'info';
}

let nextId = 1;

export const useUiStore = defineStore('ui', {
  state: () => ({
    toasts: [] as Toast[],
  }),
  actions: {
    addToast(title: string, message: string, type: Toast['type'] = 'info') {
      const toast: Toast = { id: nextId++, title, message, type };
      this.toasts.push(toast);
      setTimeout(() => this.dismiss(toast.id), 4000);
    },
    dismiss(id: number) {
      this.toasts = this.toasts.filter((t) => t.id !== id);
    },
    $reset() {
      this.toasts = [];
    },
  },
});
```

> Render `toasts` in `App.vue` via a teleported component. Consumers only call `addToast()`.

## 🛡️ Guardrails

- **Views never call `supabase` directly** — every data read goes through a store action. If you see `supabase.from(...)` in a `.vue` file, move it to the store.
- **Fail-closed redirect, not error text** — `getDetail() === null` → `router.replace('/courses')`. Don't render "Not found" as the page content.
- **Sequential `await` across auth boundaries** — `await authStore.fetchUser()` must complete before any data store call. `Promise.all` is fine for truly independent queries (both already-authenticated reads).
- **Script block order** — 1–6 (from Step 08 §4). Every view.
- **Empty state is a feature, not an afterthought** — every list view must have one (not just a blank area).
- **Toast all feedback** — success + error. `alert()` and raw text are forbidden.
- **No cross-view business logic** — logic lives in stores. Views are presentational. If a view has `if-else-if-else` for business rules, refactor to the store.
- **Mobile max-width** — `max-w-[480px] mx-auto` on every top-level view. The webApp is phone-shaped even on desktop.

## ✅ Verify

```bash
# 1. No direct supabase imports in views
grep -rn "from '@/config'" src/views/ --include="*.vue" | grep supabase
# Expected: empty (only stores import supabase)

# 2. Every top-level view has the mobile shell
grep -rn "max-w-\[480px\]" src/views/ --include="*.vue"
# Expected: matches every list.vue / detail.vue / index.vue

# 3. No alert() or console.alert in views
grep -rn "alert(" src/views/ --include="*.vue"
# Expected: empty

# 4. Every view has the 6 numbered script blocks
grep -l "// 1\. Imports" src/views/**/*.vue | wc -l
# Expected: count = total view files
```

## ♻️ Rollback
```bash
rm -rf src/views/<feature>/
# Remove matching route entries from src/router/index.ts
```

## → Next Step
**[10-routing-logic](../10-routing-logic/skill.md)** — register each view with meta.requiresAuth + meta.title.
**[12-i18n-composables](../12-i18n-composables/skill.md)** — if multi-language, wire up vue-i18n.
