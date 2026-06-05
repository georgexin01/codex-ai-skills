# Vue 3 Mobile Admin App Patterns

> Learned from: CY Roro Bin Rental (trash-container-app)  
> Applies to: Vue 3 + Pinia + Tailwind mobile-first admin/driver apps

---

## Two-Level Tab Filter Pattern

Use when data has two independent classification axes (type × status).  
Example: tasks have `type` (delivery/pickup) AND `order.status` (pending/active/complete/failed).

```ts
// Outer tab: type
const activeTypeTab = ref<'delivery' | 'pickup'>('delivery')

// Inner pills: status (maps UI label → array of DB statuses)
const orderStatusMap: Record<string, string[]> = {
  pending:  ['pending'],
  active:   ['assigned', 'delivering', 'delivered', 'pickingUp'],
  complete: ['completed'],
  failed:   ['failed', 'cancelled'],
}
const activeStatusTab = ref<'pending' | 'active' | 'complete' | 'failed'>('pending')

// Filtered result — two-step filter
const filteredTasks = computed(() => {
  let tasks = store.items.filter(t => t.type === activeTypeTab.value)
  const orderStatuses = orderStatusMap[activeStatusTab.value]
  return tasks.filter(t => orderStatuses.includes(t.order?.status ?? ''))
})
```

**Count badges on type tabs** — show only "live" count (pending + active), not historical:
```ts
const activeOrderStatuses = [...orderStatusMap.pending, ...orderStatusMap.active]
const deliveryCount = computed(() =>
  store.items.filter(t =>
    t.type === 'delivery' && activeOrderStatuses.includes(t.order?.status ?? '')
  ).length
)
```

**IMPORTANT:** Card status badge should use `task.order.status` (not `task.status`).  
They are different fields. The tab filters by order.status; the badge must match.

---

## Driver Tasks as Primary Admin Data Source

Instead of showing raw `orders` in an admin panel, show `driver_tasks`.  
Each order generates 2 tasks: one `delivery` + one `pickup`.

**Why tasks > orders for admin view:**
- Tasks have driver assignment, scheduled date, photo evidence
- Tasks have GPS coordinates at start + complete
- Tasks show operational status independent of order status
- Admin can filter by delivery vs pickup separately

```ts
// Admin store — fetches ALL tasks (no driverId filter)
// Driver store — fetches only tasks WHERE driverId = current driver

// Key difference in select query:
// Admin: .from('driver_tasks').select(TASK_SELECT).eq('isDelete', false)
// Driver: .from('driver_tasks').select(TASK_SELECT).eq('driverId', driverId).eq('isDelete', false)
```

---

## Custom Tailwind Dropdown (Replacing Native Select)

Native `<select>` can't be styled consistently. Replace with:

```vue
<template>
  <div class="relative">
    <!-- Trigger button -->
    <button @click="dropOpen = !dropOpen" class="w-full flex items-center justify-between p-3 border rounded-xl">
      <span>{{ selectedLabel || 'Select...' }}</span>
      <ChevronDown :size="16" />
    </button>

    <!-- Search + options dropdown -->
    <div v-if="dropOpen" class="absolute z-50 w-full mt-1 bg-white border rounded-xl shadow-lg">
      <input v-model="search" placeholder="Search..." class="w-full px-3 py-2 border-b text-sm" />
      <div class="max-h-52 overflow-y-auto">
        <button
          v-for="item in filtered"
          :key="item.id"
          @click="select(item); dropOpen = false"
          class="w-full flex items-center gap-3 px-3 py-2 hover:bg-slate-50"
        >
          <!-- Avatar initials -->
          <div class="size-8 rounded-full bg-primary/10 flex items-center justify-center text-primary font-bold text-xs">
            {{ item.name.slice(0,2).toUpperCase() }}
          </div>
          <span class="flex-1 text-sm text-left">{{ item.name }}</span>
          <Check v-if="selectedId === item.id" :size="14" class="text-primary" />
        </button>
      </div>
    </div>
  </div>

  <!-- Click-away overlay -->
  <div v-if="dropOpen" @click="dropOpen = false" class="fixed inset-0 z-40" />
</template>
```

Pattern reused for: Customer selector, Driver selector, Bin size selector.

---

## Leaflet Map + Deep-Link Navigation

Map pins that link to list items across routes.

```ts
// 1. Map view: popup "View Detail" button navigates with query param
onclick="window.location.href='/orders?orderId=${task.orderId}'"

// 2. Target view: detect deep-link on mount
onMounted(async () => {
  await store.getAllTasks()
  if (route.query.orderId) {
    const task = store.items.find(t => t.orderId === route.query.orderId)
    if (task) selectedTask.value = task
  }
})

// 3. Clear deep-link (back to list)
function clearDeepLink() {
  router.replace({ query: {} })
  selectedTask.value = null
}

// 4. isDeepLinked computed — changes header title + shows back button
const isDeepLinked = computed(() => !!route.query.orderId)
```

**Marker keying:** Use `task.id` as map key (not `order.id`). There are 2 tasks per order.

---

## GYOR Color System (Bin Expiry Map)

GYOR = Green / Yellow / Orange / Red — encodes time urgency.

```ts
const getGYORKey = (task: any): 'green' | 'yellow' | 'orange' | 'red' => {
  const pickupDate = task.order?.pickupDate
  if (!pickupDate) return 'green'   // Not yet scheduled = no urgency
  const diff = new Date(pickupDate).getTime() - Date.now()
  if (diff < 0) return 'red'        // Expired (overdue pickup)
  if (diff < 86400000) return 'orange'      // < 1 day
  if (diff < 86400000 * 3) return 'yellow'  // < 3 days
  return 'green'
}

const GYOR_COLORS = {
  green:  '#4CAF50',
  yellow: '#FBC02D',
  orange: '#F57C00',
  red:    '#F44336',   // pulses with CSS animation
}
```

**Stat counters** on map sidebar show: N Bins Normal / In 3 Days / Today / Expired.  
Clicking a stat row calls `jumpToNext(colorKey)` — cycles through matching markers.

---

## Compact Map Popup (Leaflet)

Keep popups tiny — show only essential info, drive to full detail via link.

```ts
const buildPopupContent = (task: any) => {
  const isPickup = task.type === 'pickup'
  const date = isPickup ? task.order?.pickupDate : task.order?.deliveryDate
  const dateStr = date
    ? new Date(date).toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: '2-digit' })
    : '—'
  const addr = task.order?.deliveryAddress || 'N/A'
  const shortAddr = addr.length > 35 ? addr.slice(0, 33) + '…' : addr

  return `
    <div style="font-family:sans-serif;width:190px;padding:9px 11px;cursor:pointer;"
         onclick="window.location.href='/orders?orderId=${task.orderId}'">
      <p style="font-size:9px;font-weight:900;color:#94a3b8;...">${task.taskNo}</p>
      <p style="font-size:13px;font-weight:700;color:#0f172a;...">${task.order?.customer?.name}</p>
      <p style="font-size:10px;font-weight:600;color:#6366f1;">${isPickup ? 'Pickup' : 'Delivery'} · ${dateStr}</p>
      <p style="font-size:10px;color:#64748b;">${shortAddr}</p>
      <div style="border-top:1px solid #f1f5f9;padding-top:5px;display:flex;justify-content:space-between;color:#6366f1;">
        <span style="font-size:10px;font-weight:900;text-transform:uppercase;">View Detail</span>
        <svg ...chevron right.../></svg>
      </div>
    </div>
  `
}
```

**Rule:** 4 lines max in a map popup: ID, Title, Type+Date, Address. One action button.

---

## Dual-Mode Modal (Task OR Order)

`OrderDetailModal.vue` accepts both task-shaped and order-shaped props via `:order`.  
It detects mode by checking for `taskNo` field:

```ts
const isTask = computed(() => !!props.order?.taskNo)
const taskData = computed(() => isTask.value ? props.order : null)
const orderData = computed(() => isTask.value ? props.order?.order : props.order)
```

This lets the same modal be opened from:
- HomeView (task card → shows task info + order info)
- A hypothetical order list (order card → shows order info only)

---

## Bottom Navigation (Admin App)

5-tab bottom nav for admin app:

```
Map | Orders | Debt | Fleet | Payroll
```

Tab active state via `$route.path.startsWith('/tab-path')`.  
Active icon: filled color. Inactive: slate-400.  
Central action button (if needed): 56px rounded-full bg-primary.

---

## Task Card Design (Driver App)

Enhanced task card shows all operational info at a glance:

```
[taskNo]                    [status badge]
[Customer Name]             [RM amount]
──────────────────────────────────────
[Bin Size]    [Task Type]   [Date]
──────────────────────────────────────
📍 [address]               [Navigate →]
```

- Status badge uses `task.order.status` (not task.status)
- Date: delivery → deliveryDate, pickup → pickupDate
- Navigate button opens Google Maps with coordinates

---

## Pinia Store Best Practices (from this project)

```ts
// 1. Always export from stores/index.ts barrel
export { useDriverTasksStore } from './driverTasks'

// 2. normalizeTask() — sanitize Supabase response before storing
function normalizeTask(row: any): DriverTask {
  return {
    ...row,
    startPhotos: toStringArray(row.startPhotos),   // jsonb → string[]
    completePhotos: toStringArray(row.completePhotos),
    order: row.order ? { ...row.order } : undefined,
    driver: row.driver ?? undefined,
  }
}

// 3. Always implement $reset() in option stores
$reset() {
  this.items = []
  this.loading = false
},

// 4. Mock data same shape as real data — enables instant switch to real DB
// 5. Loading state in store, not component — prevents double-loading
```

---

## Scheduled Date: Delivery vs Pickup

Orders have TWO dates: `deliveryDate` and `pickupDate`.  
Show the relevant date based on task type:

```ts
const scheduledDate = task.type === 'pickup'
  ? task.order?.pickupDate
  : task.order?.deliveryDate

// Format:
function formatDate(dateStr: string) {
  if (!dateStr) return '—'
  return new Date(dateStr).toLocaleDateString('en-GB', {
    day: '2-digit', month: 'short', year: 'numeric'
  })
}
```

**Bug to avoid:** Always using `deliveryDate` for both types.  
Pickup tasks would show the delivery date from days ago instead of today's pickup date.
