---
name: generate-i18n
description: Generate zh-CN and en-US i18n JSON translations for a module from its analyzed schema.
triggers: ["generate i18n", "translations", "locale json", "zh en translations"]
phase: 2-scaffold
requires: [analyze-schema]
unlocks: []
inputs: [entity_definition, field_list]
output_format: json_files
model_hint: gpt-5.3-codex
version: 2.0
---

# Generate Internationalization (generate-i18n)

Generate internationalization configuration based on the analyzed table structure.

## Description

Generate complete i18n translation configuration:
- Chinese (primary language)
- English (secondary language)

## Prerequisites

Must run `/analyze-schema` first to confirm table structure and fields.

## File Locations

```
apps/web-antd/src/locales/langs/
├── zh-CN/
│   └── page.json    # Chinese translations
└── en-US/
    └── page.json    # English translations
```

## i18n Structure Template

### Base Structure

```json
{
  "{{ENTITIES}}": {
    "title": "{{ENTITY_LABEL}} Management",
    "list": "{{ENTITY_LABEL}} List",
    "detail": "{{ENTITY_LABEL}} Detail",
    "table": {
      // Table column titles
    },
    "form": {
      // Form fields
    },
    "toolbar": {
      // Toolbar buttons
    },
    "drawer": {
      // Drawer titles
    },
    "actions": {
      // Action buttons (for O2M/M2M)
    }
  }
}
```

### Complete Example (Chinese)

```json
{
  "students": {
    "title": "学生管理",
    "list": "学生列表",
    "detail": "学生详情",
    "table": {
      "name": "姓名",
      "email": "邮箱",
      "phone": "电话",
      "homeroomTeacher": "班主任",
      "status": "状态"
    },
    "form": {
      "name": "姓名",
      "namePlaceholder": "请输入学生姓名",
      "nameRequired": "请输入学生姓名",
      "email": "邮箱",
      "emailPlaceholder": "请输入邮箱",
      "emailInvalid": "请输入有效的邮箱地址",
      "phone": "电话",
      "phonePlaceholder": "请输入电话",
      "homeroomTeacher": "班主任",
      "homeroomTeacherPlaceholder": "请选择班主任",
      "status": "状态",
      "statusPlaceholder": "请选择状态"
    },
    "toolbar": {
      "create": "新建学生",
      "addRelation": "添加学生"
    },
    "drawer": {
      "createTitle": "创建学生",
      "editTitle": "编辑学生"
    },
    "actions": {
      "manageTeachers": "管理任课老师",
      "manageSubjects": "管理学习科目"
    }
  }
}
```

### Complete Example (English)

```json
{
  "students": {
    "title": "Students",
    "list": "Student List",
    "detail": "Student Detail",
    "table": {
      "name": "Name",
      "email": "Email",
      "phone": "Phone",
      "homeroomTeacher": "Homeroom Teacher",
      "status": "Status"
    },
    "form": {
      "name": "Name",
      "namePlaceholder": "Enter student name",
      "nameRequired": "Please enter student name",
      "email": "Email",
      "emailPlaceholder": "Enter email",
      "emailInvalid": "Please enter a valid email address",
      "phone": "Phone",
      "phonePlaceholder": "Enter phone number",
      "homeroomTeacher": "Homeroom Teacher",
      "homeroomTeacherPlaceholder": "Select homeroom teacher",
      "status": "Status",
      "statusPlaceholder": "Select status"
    },
    "toolbar": {
      "create": "New Student",
      "addRelation": "Add Student"
    },
    "drawer": {
      "createTitle": "Create Student",
      "editTitle": "Edit Student"
    },
    "actions": {
      "manageTeachers": "Manage Teachers",
      "manageSubjects": "Manage Subjects"
    }
  }
}
```

## Field Type Translation Patterns

### Table Columns (table)

```json
{
  "table": {
    "{{fieldName}}": "{{Field Label}}"
  }
}
```

### Form Fields (form)

| Suffix | Purpose | Chinese Template | English Template |
| --- | --- | --- | --- |
| (none) | Field label | `{{Chinese name}}` | `{{English Name}}` |
| Placeholder | Placeholder text | `请输入{{Chinese name}}` | `Enter {{english name}}` |
| Required | Required error | `请输入{{Chinese name}}` | `Please enter {{english name}}` |
| Invalid | Validation error | `请输入有效的{{Chinese name}}` | `Please enter a valid {{english name}}` |

### FK Field Special Translations

```json
{
  "form": {
    "homeroomTeacher": "Homeroom Teacher",
    "homeroomTeacherPlaceholder": "Select homeroom teacher"
  }
}
```

### M2M Action Translations

```json
{
  "actions": {
    "manage{{RelatedEntity}}s": "Manage {{Related Entity Label}}"
  },
  "drawer": {
    "selectTitle": "Select {{Related Entity Label}}"
  }
}
```

## Parent Menu Translations

If it's a new parent menu, add:

```json
{
  "schoolManagement": {
    "title": "School Management",
    "subjects": "Subject Management",
    "teachers": "Teacher Management",
    "students": "Student Management"
  }
}
```

## Common Translations (Pre-existing)

The following translations are already defined in `page.json` and should not be duplicated:

```json
{
  "table": {
    "common": {
      "seq": "No.",
      "actions": "Actions",
      "status": "Status",
      "statusPlaceholder": "Select status",
      "createdAt": "Created At",
      "updatedAt": "Updated At"
    },
    "status": {
      "active": "Active",
      "inactive": "Inactive"
    },
    "actions": {
      "view": "View Details",
      "edit": "Edit",
      "delete": "Delete",
      "remove": "Remove",
      "select": "Select"
    },
    "button": {
      "create": "Create",
      "save": "Save",
      "cancel": "Cancel"
    }
  },
  "modal": {
    "cancel": "Cancel",
    "confirm": "Confirm",
    "deleteTitle": "Confirm Delete",
    "deleteContent": "Are you sure you want to delete \"{name}\"? This action cannot be undone.",
    "deleteSuccess": "Deleted successfully",
    "deleteFailed": "Delete failed",
    "removeTitle": "Confirm Remove",
    "removeRelationContent": "Are you sure you want to remove the relation with \"{name}\"?",
    "removeSuccess": "Removed successfully",
    "removeFailed": "Remove failed"
  }
}
```

## Output Checklist

```
## i18n Configuration Complete

Modified: locales/langs/zh-CN/page.json
   - Added {{ENTITIES}} translation node
   {{#if NEW_PARENT_MENU}}
   - Added {{parentMenu}} parent menu translations
   {{/if}}

Modified: locales/langs/en-US/page.json
   - Added {{ENTITIES}} translation node
   {{#if NEW_PARENT_MENU}}
   - Added {{parentMenu}} parent menu translations
   {{/if}}

### Translation Structure
page.{{ENTITIES}}
├── title
├── list
├── detail
├── table.* ({{field count}} fields)
├── form.* ({{form field count}} fields)
├── toolbar.*
├── drawer.*
{{#if HAS_ACTIONS}}
└── actions.*
{{/if}}

### Module Generation Complete!
All files have been generated. Run `pnpm dev:local` to test with Docker local Supabase.
```

## Notes

1. Chinese is the primary language, English is the secondary language
2. Use `{name}` syntax for parameter substitution
3. Maintain consistency with the existing translation structure
4. Do not duplicate common translations
5. FK field translations use the related entity's label

