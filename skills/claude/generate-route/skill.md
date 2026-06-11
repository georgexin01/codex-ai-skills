---
name: generate-route
description: Generate or update Vue Router route modules with menu icon, order, and nested list/detail routes.
triggers: ["generate route", "vue router", "add menu", "route configuration"]
phase: 2-scaffold
requires: [generate-views]
unlocks: []
inputs: [entity_definition, menu_placement]
output_format: typescript_file
model_hint: gpt-5.3-codex
version: 2.0
---

# Generate Route Configuration (generate-route)

Generate route configuration based on the analyzed table structure.

## Description

Generate or update Vue Router route configuration:
- Add to existing route module or create a new module
- Configure list and detail routes
- Set menu icon, order, permissions

## Prerequisites

Must run `/generate-views` first to ensure components are generated.

## Route File Location

```
apps/web-antd/src/router/routes/modules/
├── school-management.ts   # School management module
├── clients.ts             # Client management module
├── businesses.ts          # Business management module
└── ...
```

## Route Configuration Template

### New Route Module

```typescript
// router/routes/modules/{{PARENT_MENU}}.ts
import type { RouteRecordRaw } from 'vue-router';

import { $t } from '@vben/locales';

const routes: RouteRecordRaw[] = [
  {
    meta: {
      icon: '{{PARENT_MENU_ICON}}',
      order: {{PARENT_MENU_ORDER}},
      title: $t('page.{{PARENT_MENU}}.title'),
    },
    name: '{{PARENT_MENU_PASCAL}}',
    path: '/{{PARENT_MENU}}',
    children: [
      // Child routes go here
    ],
  },
];

export default routes;
```

### Add Entity Routes

```typescript
// Add to children array

// List route
{
  name: '{{ENTITY_NAME}}List',
  path: '/{{ENTITIES}}/list',
  component: () => import('#/views/{{ENTITIES}}/{{ENTITY_NAME_LOWER}}-list.vue'),
  meta: {
    icon: '{{MENU_ICON}}',
    keepAlive: true,
    title: $t('page.{{ENTITIES}}.list'),
  },
},

// Detail route (hideInMenu: true)
{
  name: '{{ENTITY_NAME}}Detail',
  path: '/{{ENTITIES}}/detail/:id',
  component: () => import('#/views/{{ENTITIES}}/{{ENTITY_NAME_LOWER}}-detail.vue'),
  meta: {
    hideInMenu: true,
    icon: '{{MENU_ICON}}',
    title: $t('page.{{ENTITIES}}.detail'),
    keepAlive: true,
  },
},
```

## Route Configuration Rules

### 1. Naming Conventions

| Item | Format | Example |
| --- | --- | --- |
| Route name | PascalCase + function | `StudentList`, `StudentDetail` |
| Route path | kebab-case | `/students/list`, `/students/detail/:id` |
| Component path | kebab-case | `#/views/students/student-list.vue` |

### 2. meta Fields

| Field | Description | Example |
| --- | --- | --- |
| icon | Menu icon | `lucide:users` |
| title | Menu title (i18n) | `$t('page.students.list')` |
| order | Menu sort order | `3` |
| keepAlive | Cache component | `true` |
| hideInMenu | Hide from menu | `true` (detail pages) |

### 3. Menu Order Recommendations

Arrange order based on business logic:

```
school-management (order: 2)
├── subjects (order: 1)     # Base configuration
├── teachers (order: 2)     # Personnel management
└── students (order: 3)     # Depends on the above
```

### 4. Parent Menu Configuration

If the parent menu does not exist, create it first:

```typescript
// router/routes/modules/school-management.ts
const routes: RouteRecordRaw[] = [
  {
    meta: {
      icon: 'lucide:school',
      order: 2,
      title: $t('page.schoolManagement.title'),
    },
    name: 'SchoolManagement',
    path: '/school-management',
    children: [
      // ...
    ],
  },
];
```

## Complete Example

### school-management.ts

```typescript
import type { RouteRecordRaw } from 'vue-router';

import { $t } from '@vben/locales';

const routes: RouteRecordRaw[] = [
  {
    meta: {
      icon: 'lucide:school',
      order: 2,
      title: $t('page.schoolManagement.title'),
    },
    name: 'SchoolManagement',
    path: '/school-management',
    children: [
      // Subjects
      {
        name: 'SubjectList',
        path: '/subjects/list',
        component: () => import('#/views/subjects/subject-list.vue'),
        meta: {
          icon: 'lucide:book-open',
          keepAlive: true,
          title: $t('page.subjects.list'),
        },
      },
      {
        name: 'SubjectDetail',
        path: '/subjects/detail/:id',
        component: () => import('#/views/subjects/subject-detail.vue'),
        meta: {
          hideInMenu: true,
          icon: 'lucide:book-open',
          title: $t('page.subjects.detail'),
          keepAlive: true,
        },
      },
      // Teachers
      {
        name: 'TeacherList',
        path: '/teachers/list',
        component: () => import('#/views/teachers/teacher-list.vue'),
        meta: {
          icon: 'lucide:user-check',
          keepAlive: true,
          title: $t('page.teachers.list'),
        },
      },
      {
        name: 'TeacherDetail',
        path: '/teachers/detail/:id',
        component: () => import('#/views/teachers/teacher-detail.vue'),
        meta: {
          hideInMenu: true,
          icon: 'lucide:user-check',
          title: $t('page.teachers.detail'),
          keepAlive: true,
        },
      },
      // Students
      {
        name: 'StudentList',
        path: '/students/list',
        component: () => import('#/views/students/student-list.vue'),
        meta: {
          icon: 'lucide:users',
          keepAlive: true,
          title: $t('page.students.list'),
        },
      },
      {
        name: 'StudentDetail',
        path: '/students/detail/:id',
        component: () => import('#/views/students/student-detail.vue'),
        meta: {
          hideInMenu: true,
          icon: 'lucide:users',
          title: $t('page.students.detail'),
          keepAlive: true,
        },
      },
    ],
  },
];

export default routes;
```

## Common Icon Reference

| Entity Type | Recommended Icon |
| --- | --- |
| Users/Personnel | `lucide:users`, `lucide:user` |
| Students | `lucide:users`, `lucide:graduation-cap` |
| Teachers | `lucide:user-check` |
| Subjects/Courses | `lucide:book-open`, `lucide:book` |
| Clients | `lucide:building-2`, `lucide:users` |
| Businesses | `lucide:briefcase` |
| Orders | `lucide:clipboard-list` |
| Finance | `lucide:wallet`, `lucide:credit-card` |
| Settings | `lucide:settings`, `lucide:cog` |
| System | `lucide:server`, `lucide:database` |

## Output Checklist

```
## Route Configuration Complete

{{Modified/New}}: router/routes/modules/{{PARENT_MENU}}.ts
   - Added {{ENTITY_NAME}}List route
   - Added {{ENTITY_NAME}}Detail route

### Menu Structure
{{PARENT_MENU}} (order: {{PARENT_MENU_ORDER}})
├── ... (existing routes)
└── {{ENTITIES}} (order: {{MENU_ORDER}})
    ├── /{{ENTITIES}}/list
    └── /{{ENTITIES}}/detail/:id (hidden)

### Next Step
Run `/generate-i18n` to generate internationalization configuration.
```

## Notes

1. Detail routes must set `hideInMenu: true`
2. All routes should set `keepAlive: true`
3. Route paths should use full paths (including parent path)
4. Ensure i18n keys already exist or are added simultaneously

