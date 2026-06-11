---
name: analyze-schema
description: Analyze user-provided table structure and confirm fields, relationships, and placeholders before code generation.
triggers: ["analyze schema", "table structure", "new entity", "confirm relationships", "analyze table"]
phase: 1-analysis
requires: []
unlocks: [generate-store, generate-supabase-schema, generate-views, generate-route, generate-i18n]
inputs: [entity_definition, field_list]
output_format: structured_confirmation
model_hint: gpt-5.3-codex
version: 2.0
---

# Analyze Table Structure (analyze-schema)

Analyze the table structure provided by the user and confirm relationship types.

## Description

When the user provides a table structure, analyze and confirm the following:
- Entity basic information (name, plural, display label)
- Field list and types
- Relationship types (none, many-to-one, one-to-many, one-to-one, many-to-many)
- Calculate placeholder values

## Trigger Conditions

Use this skill when the user requests table structure analysis or provides a new entity definition.

## Input Format

```
Entity: Student (Student)
Plural: students
Route: /school-management/students
Menu icon: lucide:users
Menu order: 3
Parent menu: school-management

Fields:
- id: string (primary key)
- name: string(100) (name, required)
- homeroomTeacherId: fk:Teacher (homeroom teacher, required) -> homeroomTeacherName
- status: enum('active','graduated','transferred') (status, default: active)
- createdAt: datetime
- updatedAt: datetime

Many-to-many:
- teachers: Teacher (assigned teachers, via student_teachers)
- subjects: Subject (enrolled subjects, via student_subjects)
```

## Naming Convention Rules

All names use **camelCase**. No snake_case, no kebab-case for code identifiers.

### Core Rule: Singular vs Plural

| Context | Case | Singular/Plural | Example |
| --- | --- | --- | --- |
| TypeScript interface | PascalCase | **Singular** | `OrderDetail`, `StockOut`, `Customer` |
| Form values type | PascalCase | **Singular** + `FormValues` | `OrderDetailFormValues` |
| Store name (function) | camelCase | **Plural** | `useOrderDetailsStore()` |
| Store ID (string) | camelCase | **Plural** | `defineStore('orderDetails', ...)` |
| Variable (single entity) | camelCase | **Singular** | `orderDetail`, `stockOut` |
| Variable (list/array) | camelCase | **Plural** | `orderDetails`, `stockOuts` |
| Field names | camelCase | - | `companyName`, `driverTelNo` |
| FK field | camelCase | **Singular** + `Id` | `vendorId`, `homeroomTeacherId` |
| FK display field | camelCase | **Singular** + name | `vendorName`, `homeroomTeacherName` |
| Database table (Supabase) | camelCase | **Plural** | `orderDetails`, `stockOuts` |
| Database column | camelCase | - | `companyName`, `driverTelNo` |
| Route path | kebab-case | **Plural** | `/order-details`, `/stock-outs` |
| Vue filename | kebab-case | **Singular** | `order-detail-list.vue`, `order-detail-form.vue` |
| i18n key path | camelCase | **Plural** | `page.orderDetails.form.name` |
| TABLE_ID constant | UPPER_SNAKE_CASE | **Singular** + `_LIST` | `ORDER_DETAIL_LIST` |
| Data refresh method | camelCase | **Plural** | `invalidateOrderDetails()` |
| Data refresh version | camelCase | **Plural** + `Version` | `orderDetailsVersion` |
| Delete modal function | PascalCase | **Singular** | `showDeleteOrderDetailModal()` |
| Drawer ID prop | camelCase | **Singular** + `Id` | `orderDetailId` |

### Multi-Word Entity Examples

**Entity: `OrderDetail`**

| Placeholder | Value |
| --- | --- |
| `ENTITY_NAME` | `OrderDetail` |
| `ENTITY_NAME_LOWER` | `orderDetail` |
| `ENTITIES` | `orderDetails` |
| `TABLE_ID` | `ORDER_DETAIL_LIST` |

```typescript
// Interface — PascalCase singular
interface OrderDetail { ... }
interface OrderDetailFormValues { ... }

// Store — camelCase plural
const orderDetailsStore = useOrderDetailsStore();
defineStore('orderDetails', () => { ... });

// Variable — camelCase singular
const orderDetail = ref<OrderDetail | null>(null);

// FK field — camelCase singular + Id
vendorId: string;
vendorName: string; // display field

// Data refresh — camelCase plural
dataRefreshStore.invalidateOrderDetails();
watch(() => dataRefreshStore.orderDetailsVersion, ...);

// Delete modal — PascalCase singular
showDeleteOrderDetailModal(id, name);

// Drawer ID prop — camelCase singular + Id
editDrawerApi.setData({ orderDetailId: row.id }).open();
```

**Entity: `StockOut`**

| Placeholder | Value |
| --- | --- |
| `ENTITY_NAME` | `StockOut` |
| `ENTITY_NAME_LOWER` | `stockOut` |
| `ENTITIES` | `stockOuts` |
| `TABLE_ID` | `STOCK_OUT_LIST` |

**Entity: `InventoryDetail`**

| Placeholder | Value |
| --- | --- |
| `ENTITY_NAME` | `InventoryDetail` |
| `ENTITY_NAME_LOWER` | `inventoryDetail` |
| `ENTITIES` | `inventoryDetails` |
| `TABLE_ID` | `INVENTORY_DETAIL_LIST` |

### File Naming (kebab-case)

Vue files always use kebab-case, derived from the entity name:

| Entity Name | List File | Form File | Detail File |
| --- | --- | --- | --- |
| `Customer` | `customer-list.vue` | `customer-form.vue` | `customer-detail.vue` |
| `OrderDetail` | `order-detail-list.vue` | `order-detail-form.vue` | `order-detail-detail.vue` |
| `StockOut` | `stock-out-list.vue` | `stock-out-form.vue` | `stock-out-detail.vue` |

Folder name uses kebab-case plural: `views/order-details/`, `views/stock-outs/`

## Analysis Flow

### 1. Determine Relationship Type

Check by priority:

| Priority | Condition | Type | Template |
| --- | --- | --- | --- |
| 1 | Has `Many-to-many:` section | M2M | with-m2m/ |
| 2 | Has `fk:` and `unique` | O2O | with-o2o/ |
| 3 | Has `fk:` | FK (many-to-one) | with-fk/ |
| 4 | None of the above | Base | base/ |

### 2. Calculate Placeholders

| Input | Placeholder | Example Value |
| --- | --- | --- |
| `Entity: Student (Student)` | `ENTITY_NAME` | `Student` |
| | `ENTITY_LABEL` | `Student` |
| `Plural: students` | `ENTITIES` | `students` |
| | `ENTITY_NAME_LOWER` | `student` |
| | `TABLE_ID` | `STUDENT_LIST` |
| `Route: /school-management/students` | `ROUTE_PREFIX` | `students` |
| `Menu icon: lucide:users` | `MENU_ICON` | `lucide:users` |
| `Menu order: 3` | `MENU_ORDER` | `3` |
| `Parent menu: school-management` | `PARENT_MENU` | `school-management` |

### 3. Field Type Mapping

| Input Format | TypeScript | Form Component | Validation Rule | Notes |
| --- | --- | --- | --- | --- |
| `string` | `string` | `Input` | `z.string().min(1)` | |
| `string(100)` | `string` | `Input` | `z.string().min(1).max(100)` | |
| `text` | `string` | `Textarea` | `z.string()` (optional) | |
| `number` | `number` | `InputNumber` | `z.number()` | |
| `enum('a','b')` | `{{EnumName}}` (TypeScript enum) | `Select` | `'selectRequired'` | **NOT** `'a' \| 'b'` — always use enum |
| `fk:Entity` | `string` | `ApiSelect` | `'selectRequired'` | |
| `datetime` | `string` | - (not in form) | - | |

**IMPORTANT — Enum fields generate:**
1. A TypeScript `enum` in `types/{{ENTITIES}}.ts` (e.g., `enum PackingOrderStatus { PENDING = 'pending', ... }`)
2. A centralized option array with `{ value, label, color }` entries (e.g., `packingTaskStatusOptions`)
3. Helper actions in the store (`getStatusColor`, `getStatusLabel`)

The enum name is derived from the entity name + field name in PascalCase:
- Entity `PackingOrder`, field `status` → `PackingOrderStatus`
- Entity `PackingOrder`, field `type` → `PackingOrderType`
- Entity `StockOut`, field `sourceType` → `StockOutSourceType`

### 4. FK Field Parsing

Format: `fieldName: fk:RelatedEntity (label, required/optional) -> displayFieldName`

Example: `homeroomTeacherId: fk:Teacher (homeroom teacher, required) -> homeroomTeacherName`

Parsed result:
- FK field name: `homeroomTeacherId`
- Related entity: `Teacher`
- Label: `homeroom teacher`
- Required: `true`
- Display field name: `homeroomTeacherName`

### 5. M2M Relationship Parsing

Format: `relationProperty: RelatedEntity (label, via junctionTable)`

Example: `teachers: Teacher (assigned teachers, via student_teachers)`

Parsed result:
- Relation property: `teachers`
- Related entity: `Teacher`
- Label: `assigned teachers`
- Junction table: `student_teachers`

## Output Format

After analysis is complete, output the confirmation:

```
## Table Structure Analysis Result

### Basic Information
- Entity name: Student
- Label: Student
- Plural: students
- Route: /school-management/students
- Relationship type: **With FK + Many-to-many** (with-fk + M2M snippets)

### Placeholders
| Placeholder | Value |
| --- | --- |
| ENTITY_NAME | Student |
| ENTITY_LABEL | Student |
| ENTITIES | students |
| ENTITY_NAME_LOWER | student |
| TABLE_ID | STUDENT_LIST |
| ROUTE_PREFIX | students |
| MENU_ICON | lucide:users |
| MENU_ORDER | 3 |
| PARENT_MENU | school-management |

### Field Analysis
| Field Name | Type | TypeScript | Form Component | Required |
| --- | --- | --- | --- | --- |
| id | string | string | - | - |
| name | string(100) | string | Input | Yes |
| homeroomTeacherId | fk:Teacher | string | ApiSelect | Yes |
| status | enum | `StudentStatus` (enum) | Select | Yes |
| createdAt | datetime | string | - | - |
| updatedAt | datetime | string | - | - |

### Enum Definitions (to be generated in types/students.ts)
| Enum Name | Values | Options Array Name |
| --- | --- | --- |
| StudentStatus | ACTIVE='active', GRADUATED='graduated', TRANSFERRED='transferred' | studentStatusOptions |

### FK Relationships
| FK Field | Related Entity | Label | Display Field |
| --- | --- | --- | --- |
| homeroomTeacherId | Teacher | homeroom teacher | homeroomTeacherName |

### M2M Relationships
| Relation Property | Related Entity | Label | Junction Table |
| --- | --- | --- | --- |
| teachers | Teacher | assigned teachers | student_teachers |
| subjects | Subject | enrolled subjects | student_subjects |

### Next Steps
Please confirm whether the above information is correct. Once confirmed, you can use the following skills to continue:
1. `/generate-store` - Generate Pinia Store (types + Supabase CRUD)
2. `/generate-supabase-schema` - Generate SQL for database tables
3. `/generate-views` - Generate Vue components
4. `/generate-route` - Generate route configuration
5. `/generate-i18n` - Generate internationalization
```

## Notes

1. If the information provided by the user is incomplete, ask for the missing required information
2. If the relationship type is unclear, confirm with the user
3. After outputting results, wait for user confirmation; do not automatically proceed to the next step
4. **Enum fields** always map to TypeScript enums (not string unions). The enum name follows the pattern: `{{EntityName}}{{FieldPascal}}` (e.g., `PackingOrderStatus`, `StockOutSourceType`)
5. For each enum, also determine the **centralized option array name** (e.g., `packingTaskStatusOptions`, `stockOutSourceTypeOptions`) and the **label + color** for each value
6. Ask the user to confirm the color mapping for each enum value if not obvious from context

