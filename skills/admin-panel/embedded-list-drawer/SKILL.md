# Embedded List in Drawer — QuizLAA Pattern

## When to use
When clicking a related entity (e.g. category name) should open a top drawer showing all
resources under that entity — with FULL VXE toolbar (search, refresh, zoom, columns icons),
pagination ("Total X records"), and row actions.

## Pattern (100% quizLAA match)

### 1. Add props to the list component
```typescript
interface Props {
  categoryId?: string;
  embedded?: boolean;
}
const props = withDefaults(defineProps<Props>(), { categoryId: '', embedded: false });
```

### 2. Update proxyConfig
```typescript
proxyConfig: {
  autoLoad: !props.embedded,   // wait for parent to call query()
  ajax: {
    query: async ({ page, sort }, formValues) => {
      const params: any = { page: page.currentPage, pageSize: page.pageSize };
      if (props.categoryId) {
        params.category_id = props.categoryId;   // or category_ids: [props.categoryId]
      } else {
        // normal form filter logic
      }
      if (sort?.field) { params.sortBy = sort.field; params.sortOrder = sort.order; }
      return await store.getList(params);
    },
  },
  sort: true,
},
```

### 3. Use different table ID for embedded (prevents localStorage conflict)
```typescript
id: props.embedded ? 'my-list-embedded' : TABLE_IDS.MY_LIST,
```

### 4. Expose query method
```typescript
defineExpose({ query: () => gridApi.query() });
```

### 5. Rewrite the drawer to embed the full list
```vue
<script lang="ts" setup>
import { nextTick, ref } from 'vue';
import { useVbenDrawer } from '@vben/common-ui';
import MyList from '../my-list.vue';

const categoryId = ref('');
const categoryName = ref('');
const listRef = ref<InstanceType<typeof MyList>>();

const [Drawer, drawerApi] = useVbenDrawer({
  footer: false,
  onOpenChange: async (isOpen) => {
    if (!isOpen) return;
    const data = drawerApi.getData<{ categoryId: string; categoryName: string }>();
    categoryId.value = data?.categoryId ?? '';
    categoryName.value = data?.categoryName ?? '';
    drawerApi.setState({ title: `Resources — ${categoryName.value}` });
    await nextTick();
    listRef.value?.query();
  },
  onClosed: () => { categoryId.value = ''; categoryName.value = ''; },
});
</script>

<template>
  <Drawer placement="top" class="h-[500px]">
    <div class="cinematic-gradient-header absolute inset-x-0 top-0 h-1 opacity-50" />
    <div class="flex h-full flex-col p-4">
      <MyList v-if="categoryId" ref="listRef" :category-id="categoryId" embedded class="flex-1" />
    </div>
  </Drawer>
</template>

<style scoped>
.cinematic-gradient-header {
  background: linear-gradient(90deg, transparent, var(--ant-color-primary, #1677ff), transparent);
}
</style>
```

## Key points
- `placement="top"` + `h-[500px]` = exact quizLAA design
- `autoLoad: !props.embedded` — parent controls when to load
- `v-if="categoryId"` — don't render until data is ready
- `await nextTick()` before calling `listRef.value?.query()` — ensures component is mounted
- The embedded list retains its full toolbar (search, refresh, zoom, columns) and pagination
- No manual subtitle bar needed — drawer title carries the category name

## Applied in angel-interior
- `sketchup-resource-list.vue` + `sketchup-category-resources-drawer.vue`
- `material-resource-list.vue` + `material-category-resources-drawer.vue`
