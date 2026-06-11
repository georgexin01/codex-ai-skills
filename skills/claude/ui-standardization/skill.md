---
name: ui-standardization
description: Enforces consistent UI patterns — Divider section headers, single-Card detail views, contact-field conventions.
triggers: ["ui standardization", "detail view layout", "section divider", "ui conventions", "card layout"]
phase: reference
requires: []
unlocks: []
inputs: []
output_format: pattern_reference
model_hint: gpt-5.3-codex
version: 2.0
---

# UI Standardization Conventions (ui-standardization)

Enforces consistent UI patterns across all detail views, form sections, and contact information fields in this admin panel.

## 1. Detail View Section Headers

**ALL detail views** must use `<Divider>` from Ant Design Vue for section headers. Never use `<h3>`, `<h4>`, or Card `:title` prop.

### Standard Pattern

```vue
<Divider orientation="left" :orientation-margin="0">
  {{ $t('page.entity.section.sectionName') }}
</Divider>
```

### Rules

- Use `orientation="left"` and `:orientation-margin="0"` on every Divider
- Section text comes from i18n keys (`$t(...)`)
- All detail content goes inside **one single `<Card>`** — never split into multiple Cards
- The Card has NO `:title` prop — sections are separated by Dividers inside the Card

### Standard Detail View Structure

```vue
<Card v-if="entity">
  <!-- Header: entity name + status tag -->
  <div class="mb-6">
    <h2 class="text-xl font-semibold">{{ entity.name }}</h2>
    <div class="mt-2">
      <Tag :color="store.getStatusColor(entity.status)">
        {{ store.getStatusLabel(entity.status) }}
      </Tag>
    </div>
  </div>

  <!-- SECTION 1 -->
  <Divider orientation="left" :orientation-margin="0">
    {{ $t('page.entity.section.section1') }}
  </Divider>
  <Descriptions :column="columnCount" bordered size="small">
    ...
  </Descriptions>

  <!-- SECTION 2 -->
  <Divider orientation="left" :orientation-margin="0">
    {{ $t('page.entity.section.section2') }}
  </Divider>
  <Descriptions :column="columnCount" bordered size="small">
    ...
  </Descriptions>

  <!-- TABLE SECTION (e.g. contacts, items) -->
  <Divider orientation="left" :orientation-margin="0">
    {{ $t('page.entity.section.items') }}
  </Divider>
  <Table ... />
</Card>
```

### Wrong Patterns (DO NOT USE)

```vue
<!-- WRONG: h3 for section headers -->
<h3 class="mb-3 font-medium">Section Title</h3>

<!-- WRONG: Multiple Cards for sections -->
<Card title="Section 1">...</Card>
<Card title="Section 2">...</Card>

<!-- WRONG: Card :title prop -->
<Card :title="$t('section.title')">...</Card>
```

## 2. EN Section Title Translations — UPPERCASE

All English (en-US) section title translations must be **UPPERCASE**. Chinese (zh-CN) titles remain in normal casing.

### Examples

| i18n Key | EN (en-US) | ZH (zh-CN) |
| --- | --- | --- |
| `section.companyInfo` | `COMPANY INFORMATION` | `公司信息` |
| `section.accountsInfo` | `ACCOUNTS INFORMATION` | `账户信息` |
| `section.contactInfo` | `CONTACT INFORMATION` | `联系信息` |
| `section.internalNotes` | `INTERNAL NOTES` | `内部备注` |
| `section.systemInfo` | `SYSTEM INFO` | `系统信息` |
| `section.orderInfo` | `ORDER INFORMATION` | `订单信息` |
| `section.truckInfo` | `TRUCK INFORMATION` | `车辆信息` |
| `section.driverInfo` | `DRIVER INFORMATION` | `司机信息` |

### Rules

- EN: Always UPPERCASE (e.g., `"COMPANY INFORMATION"`)
- ZH: Normal Chinese text (e.g., `"公司信息"`)
- This applies to both detail view Divider sections AND form Divider sections (`renderComponentContent`)

### Form Schema Divider Sections

```typescript
{
  component: 'Divider',
  componentProps: {
    orientation: 'left',
    orientationMargin: 0,
  },
  fieldName: '_divider_section',
  formItemClass: 'col-span-2',
  hideLabel: true,
  renderComponentContent: () => ({
    default: () => $t('page.entity.section.sectionName'),
    // EN value must be UPPERCASE in locale file
  }),
},
```

## 3. Contact Information Field Standardization

All modules that have contact information (dynamic contact arrays) must use the **same field labels and placeholders**.

### Standard Contact Fields

| Field | EN Label | EN Placeholder | ZH Label | ZH Placeholder |
| --- | --- | --- | --- | --- |
| Name | `Name` | `Enter contact name` | `姓名` | `请输入联系人姓名` |
| Job Position | `Job Position` | `Enter job position` | `职位` | `请输入职位` |
| Tel No. | `Tel No.` | `Enter telephone number` | `电话` | `请输入电话号码` |
| Email | `Email` | `Enter email address` | `邮箱` | `请输入邮箱地址` |

### Rules

- Use `Tel No.` (not "Phone", "Phone Number", or "Contact Phone")
- Use plain `<Input>` for all contact fields (not AutoComplete, not Select)
- Section title: `CONTACT INFORMATION` (EN) / `联系信息` (ZH)
- Contact array is managed outside the form schema (separate `ref<Array>`)
- Contact fields use `size="small"` in detail/form views

### Standard Contact Section Template

```vue
<!-- Section header -->
<div class="mb-2 flex items-center justify-between">
  <span class="font-medium">{{ $t('page.entity.form.contacts') }}</span>
  <Button type="primary" size="small" @click="addContact">
    <template #icon>
      <IconifyIcon icon="lucide:plus" />
    </template>
  </Button>
</div>

<!-- Empty state -->
<div v-if="contacts.length === 0" class="py-4 text-center text-gray-400">
  {{ $t('page.entity.form.noContacts') }}
</div>

<!-- Contact cards -->
<Card v-for="(contact, index) in contacts" :key="index" size="small">
  <div class="grid grid-cols-2 gap-3">
    <div>
      <label class="mb-1 block text-sm text-gray-500">
        {{ $t('page.entity.form.contactName') }}
      </label>
      <Input v-model:value="contact.name" :placeholder="..." size="small" />
    </div>
    <!-- More fields... -->
    <Button type="text" danger size="small" @click="removeContact(index)">
      <template #icon>
        <IconifyIcon icon="lucide:trash-2" />
      </template>
    </Button>
  </div>
</Card>
```

## Checklist

When creating or modifying detail views or forms with sections:

- [ ] Detail view uses single `<Card>` with `<Divider>` sections (no multi-Card, no `<h3>`)
- [ ] Divider has `orientation="left"` and `:orientation-margin="0"`
- [ ] EN section titles are UPPERCASE in locale file
- [ ] ZH section titles are normal Chinese text
- [ ] Contact fields use standardized labels: Name, Job Position, Tel No., Email
- [ ] Contact fields use `<Input>` (not AutoComplete or Select)
- [ ] Contact section title is "CONTACT INFORMATION" (EN) / "联系信息" (ZH)

