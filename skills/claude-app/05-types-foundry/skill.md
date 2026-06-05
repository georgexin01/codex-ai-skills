---
name: frontend-05-types-foundry
description: "Step 05 — src/types/: DB types, App types, request/response contracts. Two-layer type system — stores transform DB shapes into App shapes; views only consume App types."
triggers: ["types foundry", "src/types", "db types", "app types", "dbToApp", "type contracts", "typescript interfaces"]
phase: 2-scaffold
requires: [frontend-02-config-hardening]
unlocks: [frontend-04-auth-architecture, frontend-06-industrial-stores, frontend-09-view-scaffolding]
output_format: typescript
version: 2.0
status: authoritative
last_updated: "2026-04-20"
---

# Step 05 — Types Foundry (the `src/types/` pillar)

## 🎯 When to Use
Right after `src/config/` (Step 02). Can run in parallel with Step 04 (auth) since the auth store depends on `UserProfile` + `LoginParams` from here.

**Why types are their own step:** the user anchored `src/types/` as one of the 6 load-bearing folders. Types are the contract layer — wrong shapes → silent UI bugs. Centralizing here means the Code Vault is copy-once, not bolted onto every store file.

## ⚠️ Dependencies
- **02-config-hardening** — `env` and `supabase` exports exist (not strictly consumed by types, but types that reference DB casing assumptions depend on knowing `env.SUPABASE_SCHEMA` = quizLaa).

## 📋 Procedure

1. **Create `src/types/` folder**.
2. **For each entity**, create `src/types/<entity>.ts` that exports:
   - `DB<Entity>` interface — mirrors DB shape 1:1 (camelCase quoted fields for `quizLaa.*`, snake_case for `public.*`).
   - `<Entity>` interface — UI-friendly shape consumed by views.
   - The `dbToApp` transform lives in the store (Step 06), NOT here — types only declare shapes.
3. **Create `src/types/index.ts`** (barrel) — re-export all entity types. All consumers import from `@/types`, never `@/types/<entity>` directly.
4. **Enforce casing rules** (see §Guardrails) — the #1 source of silent-empty PostgREST responses.

## 📦 Code Vault

### §1. `src/types/auth.ts` (auth contracts — used by Step 04)
```ts
export interface UserProfile {
  agentId: string;
  rawId: string;            // untruncated UUID — needed for FK writes
  avatar: string;
  completedModules: number;
  email: string;
  id: string;
  monthlyProgress: number;
  name: string;
  nameEn: string;
  remainingHours: number;
  roles: string[];
  title: string;
  titleEn: string;
  totalModules: number;
}

export interface LoginParams {
  email: string;
  password: string;
}

export interface LoginResult {
  accessToken: string;
  agentId: string;
  avatar: string;
  email: string;
  id: string;
  name: string;
  nameEn: string;
  roles: string[];
  title: string;
  titleEn: string;
}

export interface UserInfoResult {
  agentId: string;
  avatar: string;
  email: string;
  id: string;
  name: string;
  nameEn: string;
  roles: string[];
  title: string;
  titleEn: string;
}
```

### §2. `src/types/lessons.ts` (entity contracts example — DB vs App two-layer)
```ts
/** DB type — mirrors quizLaa.lessons 1:1 */
export interface Lesson {
  id: string;
  images: string[];
  video: string;
  title: string;
  description: string;
  duration: number;
  sort: number;
}

/** App type — transformed for UI (story: Course card with progress + bestScore) */
export interface Course {
  id: string;
  title: string;
  description: string;
  duration: string;          // "15 min" — pre-formatted
  questionsCount: number;    // joined via Step 06 intersection query
  image: string;             // first element of images[]
  tag?: string;
  progress?: number;
  sort?: number;
  isPassed?: boolean;
  bestScore?: number;
}
```

### §3. `src/types/questions.ts`
```ts
/** DB type — raw question + JSONB answers array */
export interface DBQuestionAnswer {
  text: string;
  isCorrect: boolean;
}

export interface DBQuestion {
  id: string;
  lessonId: string;
  title: string;
  purposeForQuestion?: string;
  answers: DBQuestionAnswer[];   // JSONB Array from Vben admin
}

/** App types — transformed for UI */
export interface QuestionOption {
  key: string;                    // 'A' | 'B' | 'C' | 'D' (post-shuffle)
  text: string;
}

export interface Question {
  id: string;
  lessonId: string;
  text: string;
  options: QuestionOption[];
  correctKey: string;
  explanation?: string;
}
```

### §4. `src/types/question-answers.ts` (snapshot pattern)
```ts
import type { Question } from './questions';

/**
 * Frozen snapshot of a single answered question.
 * Stored as JSONB — immutable, so replayed review pages show
 * exactly what the user saw even if the source question is edited later.
 */
export interface AnswerSnapshot {
  questionId: string;
  options: string[];    // options in the exact order the user saw (post-shuffle)
  correctKey: string;   // 'A' | 'B' | 'C' | 'D' — index into options
  selectedKey: string;  // 'A' | 'B' | 'C' | 'D' — index into options
}

/** DB type — raw submission row from quizLaa.questionAnswers */
export interface QuestionAnswer {
  id: string;
  userId: string;
  lessonId: string;
  answers: AnswerSnapshot[] | Record<string, string>;   // legacy or new shape
  score: string | number;
  totalQuestion: number;
  totalRightAnswer: number;
  submittedAt?: string;
  isDelete?: boolean;
}

/** In-memory attempt passed to result/review pages */
export interface QuizAttempt {
  date: string;
  score: number;
  totalQuestions: number;
  correctCount: number;
  subjectName: string;
  questions: Question[];
  userAnswers: Record<string, string>;   // legacy support
  snapshots: AnswerSnapshot[];           // new robust storage
}

/** History list entry (derived from QuestionAnswer + joined Lesson) */
export interface HistoryRecord {
  id: string;
  title: string;
  date: string;
  score: number;
  tag: string;
  icon: string;
  totalQuestions: number;
  correctCount: number;
  questions: Question[];
  userAnswers: Record<string, string>;
  snapshots: AnswerSnapshot[];
}
```

### §5. `src/types/user-lessons.ts` (M2M junction projection)
```ts
/**
 * Minimal projection for the student webapp. Only the fields needed
 * to gate visibility on the homepage + the detail guard.
 */
export interface UserLesson {
  id: string;
  userId: string;
  lessonId: string;
  assignDate: string;
  isDelete: boolean;
}
```

### §6. `src/types/index.ts` (barrel)
```ts
export * from './auth';
export * from './lessons';
export * from './questions';
export * from './question-answers';
export * from './user-lessons';
```

### §7. Optional: `src/types/localStorageType.ts` (typed localStorage keys)
```ts
/**
 * Typed localStorage key registry. Prevents typos at callsites.
 * Usage:
 *   localStorage.setItem(LS.accessToken, token);
 *   const t = localStorage.getItem(LS.accessToken);
 */
export const LS = {
  accessToken: 'accessToken',
  lastAttemptId: 'lastAttemptId',
  uiTheme: 'uiTheme',
} as const;

export type LocalStorageKey = keyof typeof LS;
```

## 🛡️ Guardrails

- **Rule #1 (schema isolation)** — types for `quizLaa.*` and `public.*` are physically separate files; never mix them in one interface. E.g., `UserProfile` (app shape) may contain fields derived from BOTH `public.user.project_id` AND `quizLaa.users.name`, but the DB types stay separate.
- **Casing rule (critical)** — `quizLaa.*` tables use `isDelete`, `userId`, `lessonId`, `createdAt` (camelCase, quoted in SQL). `public.*` tables use `is_delete`, `auth_id`, `project_id`, `created_at` (snake_case). Your TS interface MUST match the column the query uses, or PostgREST silently returns empty/null for that field.
- **Table-name casing quirks** — `quizLaa.questionAnswers` and `quizLaa.testProducts` are camelCase; everything else is snake_case or single-word. Using `question_answers` in `.from()` returns empty data with no error.
- **DB type vs App type** — every entity has both. Transform function lives in the store (Step 06), never in views. Views import only App types.
- **Barrel discipline** — consumers `import type { Course, UserProfile } from '@/types'`. Never import from `@/types/lessons` directly — if the file is renamed, every direct import breaks.
- **JSONB fields are structured** — don't type them as `any`. Define a nested interface (e.g., `AnswerSnapshot[]`) so the shape is enforced at save + load.

## ✅ Verify

```bash
# 1. Type-check
pnpm type-check              # expect: exit code 0

# 2. Import resolution sanity
#    In any view:
#      import type { UserProfile, Course, AnswerSnapshot } from '@/types';
#    Expected: IDE auto-complete works for every field.

# 3. DB-casing audit — grep for common mistakes
grep -rn "from 'question_answers'" src/       # expect: empty (wrong casing)
grep -rn "isdelete" src/ --include="*.ts"     # expect: empty
```

## ♻️ Rollback

```bash
rm -rf src/types/
# Rebuild: re-run Step 05 with Code Vault above.
```

Types have no runtime — deleting the folder breaks the build immediately (TS resolution), which is the desired fail-fast behavior.

## → Next Step
**[06-industrial-stores](../06-industrial-stores/skill.md)** — Pinia Bakery stores that import these types and define `dbToApp` transforms.
Parallel: **[04-auth-architecture](../04-auth-architecture/skill.md)** if not already done.
