---
name: order-card-gradient
description: "Gradient Status Order Card"
triggers: ["order card gradient", "order-card-gradient", "gradient status order"]
phase: reference
model_hint: gpt-5.3-codex
version: 42.0
_ohdy_wrapper: |-
  # OHDY COMPRESSED NODE (V42.0)
  <dna_node>
  v: 42.0
  n: order-card-gradient
  graph:
    req: []
    rel: []
  l: |-
  </dna_node>
---

# Gradient Status Order Card

Score: 95 (S-CORE) | Source: lee-ming-pork OrdersView
Description: Two-tone card with gradient top (status-colored) + white bottom. Glassmorphism icon, ambient circles, item preview, price.
Reuse: Any app with order/booking/transaction list. Change: status colors, item display, price format.

## Dependencies
- `lucide-vue-next`: Package, Clock, ChevronRight + status icons
- Tailwind CSS v4

## Customize These
- `statusTheme()` — change gradient colors per your status enums
- `statusIcon()` — change icons per status
- Item preview line — change `item.name x item.quantity` to match your data
- Price format — change `RM` to your currency
- Badge text — change payment type labels

## Full Code

```vue

<router-link
  v-for="order in orders"
  :key="order.id"
  :to="`/order/${order.id}`"
  class="block rounded-[28px] overflow-hidden shadow-premium active:scale-[0.97] transition-all cursor-pointer group"
>
  
  <div
    class="relative px-5 pt-5 pb-4 text-white bg-gradient-to-br"
    :class="statusTheme(order.status).bg"
  >
    
    <div class="absolute top-0 right-0 w-28 h-28 bg-white/5 rounded-full -mr-10 -mt-10"></div>
    <div class="absolute bottom-0 left-0 w-20 h-20 bg-black/5 rounded-full -ml-8 -mb-8"></div>

    <div class="relative z-10 flex justify-between items-start">
      <div class="flex items-center gap-3">
        <div class="w-10 h-10 rounded-2xl bg-white/10 backdrop-blur-md flex items-center justify-center border border-white/10">
          <component :is="statusIcon(order.status)" :size="20" :class="statusTheme(order.status).icon" />
        </div>
        <div>
          <p class="text-sm font-black leading-tight">{{ order.status }}</p>
          <p class="text-[9px] font-bold text-white/50 uppercase tracking-widest">{{ order.id }}</p>
        </div>
      </div>
      <span class="text-[10px] font-black px-2.5 py-1 rounded-full uppercase tracking-widest" :class="statusTheme(order.status).badge">
        {{ order.paymentType === 'cod' ? '货到付款' : '预付' }}
      </span>
    </div>
  </div>

  
  <div class="bg-white px-5 py-4 border border-gray-100 border-t-0 rounded-b-[28px]">
    
    <div class="flex items-center gap-2 mb-3">
      <Package :size="13" class="text-gray-400" />
      <span class="text-[11px] font-bold text-gray-500">
        {{ order.items.slice(0, 2).map(i => `${i.name} x${i.quantity}`).join('、') }}{{ order.items.length > 2 ? ` 等${order.items.length}件` : '' }}
      </span>
    </div>

    <div class="flex justify-between items-end">
      <div class="flex items-center gap-3">
        <Clock :size="13" class="text-gray-400" />
        <span class="text-[10px] font-bold text-gray-400">{{ new Date(order.timestamp).toLocaleDateString('zh-CN', { month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit' }) }}</span>
      </div>
      <div class="flex items-center gap-2">
        <span class="text-lg font-black text-[#8B1A1A] tracking-tighter">RM{{ order.total }}</span>
        <ChevronRight :size="16" class="text-gray-300 group-hover:text-primary-500 group-hover:translate-x-0.5 transition-all" />
      </div>
    </div>
  </div>
</router-link>
```

## Status Theme Function (Copy This Too)

```javascript
const statusTheme = (s) => {
  if (s === '待付款') return { bg: 'from-amber-500 to-orange-600', badge: 'bg-white/20 text-white', icon: 'text-amber-200' }
  if (s === '已付款') return { bg: 'from-emerald-500 to-green-600', badge: 'bg-white/20 text-white', icon: 'text-green-200' }
  if (s === '已确认') return { bg: 'from-primary-600 to-primary-800', badge: 'bg-white/20 text-white', icon: 'text-primary-200' }
  if (s === '备货中') return { bg: 'from-blue-500 to-indigo-600', badge: 'bg-white/20 text-white', icon: 'text-blue-200' }
  if (s === '已发货') return { bg: 'from-violet-500 to-purple-700', badge: 'bg-white/20 text-white', icon: 'text-violet-200' }
  if (s === '已完成') return { bg: 'from-gray-600 to-gray-800', badge: 'bg-white/20 text-white', icon: 'text-gray-400' }
  if (s === '已取消') return { bg: 'from-red-400 to-red-600', badge: 'bg-white/20 text-white', icon: 'text-red-200' }
  return { bg: 'from-gray-500 to-gray-700', badge: 'bg-white/20 text-white', icon: 'text-gray-400' }
}
```

## Required CSS

```css
.shadow-premium {
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}
```

