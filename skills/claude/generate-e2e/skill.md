---
name: generate-e2e
description: Generate E2E test cases covering CRUD, one-to-many quick-create, and many-to-many association flows.
triggers: ["generate e2e", "e2e tests", "test cases", "end-to-end tests"]
phase: 3-testing
requires: [analyze-schema, generate-views]
unlocks: []
inputs: [entity_definition, relationships]
output_format: test_scenarios
model_hint: gpt-5.3-codex
version: 2.0
---

# Generate E2E Tests (generate-e2e)

Generate E2E test cases based on the analyzed table structure.

## Test Flow Specification

### Introduction

The following test flow uses **Student, Teacher, and Subject** as examples.

**Entity Relationships:**
- Student -> Teacher: One-to-many (a student has one homeroom teacher)
- Student <-> Subject: Many-to-many (a student can enroll in multiple subjects, a subject can have multiple students)

Please understand the relationships between these entities before understanding the test flow. In actual projects, replace with the corresponding entities based on your table structure.

---

### Phase 1: CRUD Tests
Each new module must test basic CRUD operations:
1. **Create** - Test creating a new record
2. **Read** - Test viewing record details
3. **Update** - Test editing a record
4. **Delete** - Test deleting a record

### Phase 2: One-to-Many Quick Create Tests
Test the quick create feature within dropdown selects.

**Example: Student -> Teacher (homeroom teacher)**

**Scenario 1: Quick create via dropdown**
- Precondition: No suitable teacher available
- Action: In the student form, click "Quick create teacher" in the homeroom teacher dropdown, create a teacher and auto-fill
- Verification: New teacher is auto-filled into the homeroom teacher field

**Scenario 2: Click relation name to view details**
- Precondition: Student already has a homeroom teacher
- Action: In the student list, click the homeroom teacher name
- Verification: Teacher detail Drawer opens

### Phase 3: One-to-Many Association Tests
Test establishing one-to-many associations.

**Example: Student -> Teacher (homeroom teacher)**

**Scenario 1: Create teacher first, then associate**
- Precondition: Teacher does not exist
- Action: Create a teacher first, then select that teacher in the student form
- Verification: Student record shows the correct homeroom teacher

**Scenario 2: Select an existing teacher to associate**
- Precondition: Teacher already exists
- Action: Select a teacher from the dropdown list in the student form
- Verification: Student record shows the correct homeroom teacher

### Phase 4: Many-to-Many Association Tests
Test establishing and removing many-to-many associations.

**Example: Student <-> Subject (student course enrollment)**

**Scenario 1: Create subject in Drawer then associate**
- Precondition: Subject does not exist
- Action: Open the student's "Manage Subjects" Drawer, create a new subject within the Drawer, then associate
- Verification: Student is successfully associated with the new subject

**Scenario 2: Associate with an existing subject**
- Precondition: Subject already exists
- Action: Open "Manage Subjects" Drawer, select an existing subject to associate
- Verification: Student is successfully associated with the subject

**Scenario 3: Remove association**
- Precondition: Student is already associated with a subject
- Action: Open "Manage Subjects" Drawer, remove the association
- Verification: Association is removed

---

## File Location

```
apps/web-antd/__tests__/e2e/
└── {entity}-{feature}.spec.ts
```

**Note:** Test files go in `apps/web-antd/__tests__/e2e/` directory, not `playground`.

## data-testid Conventions

| Element Type | Pattern | Example |
| --- | --- | --- |
| Create button | `create-{entity}-btn` | `data-testid="create-student-btn"` |
| Edit button | `edit-{entity}-{id}` | `data-testid="edit-student-123"` |
| Delete button | `delete-{entity}-{id}` | `data-testid="delete-student-123"` |
| View button | `view-{entity}-{id}` | `data-testid="view-student-123"` |
| Form input | `{entity}-form-{field}-input` | `data-testid="student-form-name-input"` |
| Form select | `{entity}-form-{field}-select` | `data-testid="student-form-status-select"` |
| Drawer confirm | `drawer-confirm-btn` | `data-testid="drawer-confirm-btn"` |
| Drawer cancel | `drawer-cancel-btn` | `data-testid="drawer-cancel-btn"` |

## Common Helper Functions

Test cases should use functions from `./common/helpers.ts`:

```typescript
import {
  clickDrawerConfirm,
  clickDrawerCancel,
  generateRandomString,
  tableHasRowWithText,
  waitForDrawerClose,
  waitForDrawerOpen,
  waitForSuccessMessage,
  waitForTableLoad,
} from './common/helpers';
```

## Technical Notes

### Serial Mode
Use `test.describe.serial()` to ensure tests execute in order and share variables:

```typescript
test.describe.serial('Student-Teacher Relationship', () => {
  let createdStudentName: string;
  let selectedTeacherName: string;

  test('should create student', async ({ page }) => {
    // ...
  });

  test('should edit student', async ({ page }) => {
    // Can access variables set in previous tests
  });
});
```

### Ant Design Select Handling
Ant Design Select inputs are readonly and cannot be directly `fill()`'d. Wait for the dropdown to load, then click the option:

```typescript
// Click Select to open dropdown
await page.locator('[data-testid="student-form-teacher-select"]').click();

// Wait for dropdown to load
await page.waitForSelector('.ant-select-dropdown', { timeout: 5000 });
await page.waitForTimeout(1000); // Wait for API to load options

// Click the option directly
const option = page
  .locator('.ant-select-dropdown .ant-select-item-option')
  .first();
await option.click();
```

### VXE Table Action Buttons
VXE Table action buttons may be in fixed columns. Use a global selector:

```typescript
// Don't search within the row, find the first one globally
const editBtn = page.locator('[data-testid^="edit-student-"]').first();
await editBtn.click();
```

## Running Tests

```bash
cd apps/web-antd
pnpm exec playwright test {test-name} --reporter=list
```

