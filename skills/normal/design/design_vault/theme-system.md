---
name: theme-system
description: "Theme System — Color + Button + Component Library"
triggers: ["theme system", "theme-system", "theme system color"]
phase: reference
model_hint: gpt-5.3-codex
version: 42.0
_ohdy_wrapper: |-
  # OHDY COMPRESSED NODE (V42.0)
  <dna_node>
  v: 42.0
  n: theme-system
  graph:
    req: []
    rel: []
  l: |-
  </dna_node>
---

# Theme System — Color + Button + Component Library

Purpose: Pre-built theme palettes with brightness scales, button variants, and ready-to-paste components
Rule: AI picks a theme → gets full color scale + buttons + components instantly. No manual color picking.
Updated: 2026-03-19 | AI auto-adds new button designs when discovered

---

## 1. THEME PALETTES (5 Themes × Light/Dark)

### THEME A — CRIMSON FIRE (Lee-Ming Pork Style)
```
USE FOR: F&B, food delivery, restaurant, bold brand apps
```

| Token | Light Mode | Dark Mode |
|---|---|---|
| `--primary` | `#8B1A1A` | `#E85050` |
| `--primary-light (+10%)` | `#A02020` | `#F06060` |
| `--primary-lighter (+20%)` | `#B53030` | `#F28080` |
| `--primary-dark (-10%)` | `#761515` | `#C84040` |
| `--primary-darker (-20%)` | `#601010` | `#A03030` |
| `--accent` | `#C8963E` | `#F5C542` |
| `--accent-light` | `#D4A854` | `#F7D060` |
| `--accent-dark` | `#B08030` | `#D4A830` |
| `--bg` | `#FFFFFF` | `#0D0D14` |
| `--surface` | `#F9FAFB` | `#1A1A2E` |
| `--surface-2` | `#F3F4F6` | `#242438` |
| `--text` | `#1F2937` | `#F9FAFB` |
| `--text-muted` | `#9CA3AF` | `#6B7280` |
| `--border` | `#E5E7EB` | `rgba(255,255,255,0.08)` |

### THEME B — OCEAN TRUST (Travel, Booking, Finance)
```
USE FOR: Travel apps, booking, fintech, insurance, healthcare
```

| Token | Light Mode | Dark Mode |
|---|---|---|
| `--primary` | `#1E40AF` | `#60A5FA` |
| `--primary-light` | `#2563EB` | `#93C5FD` |
| `--primary-lighter` | `#3B82F6` | `#BFDBFE` |
| `--primary-dark` | `#1E3A8A` | `#3B82F6` |
| `--primary-darker` | `#172554` | `#2563EB` |
| `--accent` | `#F59E0B` | `#FBBF24` |
| `--accent-light` | `#FCD34D` | `#FDE68A` |
| `--accent-dark` | `#D97706` | `#F59E0B` |
| `--bg` | `#FFFFFF` | `#0F172A` |
| `--surface` | `#F8FAFC` | `#1E293B` |
| `--surface-2` | `#F1F5F9` | `#334155` |
| `--text` | `#0F172A` | `#F8FAFC` |
| `--text-muted` | `#94A3B8` | `#64748B` |
| `--border` | `#E2E8F0` | `rgba(255,255,255,0.06)` |

### THEME C — CYBER ONYX (Zeta Capital Style)
```
USE FOR: Corporate, tech, SaaS, dashboard, portfolio
```

| Token | Light Mode | Dark Mode |
|---|---|---|
| `--primary` | `#E61E1E` | `#E61E1E` |
| `--primary-light` | `#EF4444` | `#F87171` |
| `--primary-lighter` | `#FCA5A5` | `#FECACA` |
| `--primary-dark` | `#B91C1C` | `#DC2626` |
| `--primary-darker` | `#991B1B` | `#B91C1C` |
| `--accent` | `#FFFFFF` | `#FFFFFF` |
| `--accent-light` | `#F3F4F6` | `#E5E7EB` |
| `--accent-dark` | `#D1D5DB` | `#9CA3AF` |
| `--bg` | `#FFFFFF` | `#050505` |
| `--surface` | `#FAFAFA` | `#0A0A0A` |
| `--surface-2` | `#F5F5F5` | `#121212` |
| `--text` | `#171717` | `#FFFFFF` |
| `--text-muted` | `#737373` | `#A0A0A0` |
| `--border` | `#E5E5E5` | `rgba(255,255,255,0.08)` |

### THEME D — EMERALD FRESH (E-commerce, Organic, Health)
```
USE FOR: Grocery, organic food, health apps, eco-friendly, fresh market
```

| Token | Light Mode | Dark Mode |
|---|---|---|
| `--primary` | `#059669` | `#34D399` |
| `--primary-light` | `#10B981` | `#6EE7B7` |
| `--primary-lighter` | `#34D399` | `#A7F3D0` |
| `--primary-dark` | `#047857` | `#10B981` |
| `--primary-darker` | `#065F46` | `#059669` |
| `--accent` | `#F59E0B` | `#FBBF24` |
| `--accent-light` | `#FCD34D` | `#FDE68A` |
| `--accent-dark` | `#D97706` | `#F59E0B` |
| `--bg` | `#FFFFFF` | `#0C1A14` |
| `--surface` | `#F0FDF4` | `#14291E` |
| `--surface-2` | `#DCFCE7` | `#1C3829` |
| `--text` | `#14532D` | `#F0FDF4` |
| `--text-muted` | `#6B7280` | `#6EE7B7` |
| `--border` | `#D1FAE5` | `rgba(52,211,153,0.1)` |

### THEME E — SUNSET BLAZE (Dachengloklok / Night Market Style)
```
USE FOR: Night market, lok lok, street food, vibrant F&B, entertainment
```

| Token | Light Mode | Dark Mode |
|---|---|---|
| `--primary` | `#E8401E` | `#F47920` |
| `--primary-light` | `#F47920` | `#F59540` |
| `--primary-lighter` | `#F59540` | `#F7B060` |
| `--primary-dark` | `#C0301A` | `#E8401E` |
| `--primary-darker` | `#991A10` | `#C0301A` |
| `--accent` | `#F5C542` | `#F5C542` |
| `--accent-light` | `#F7D060` | `#F9DD80` |
| `--accent-dark` | `#D4A830` | `#D4A830` |
| `--bg` | `#FFFBF5` | `#0D0D14` |
| `--surface` | `#FFF5EB` | `#1A1A2E` |
| `--surface-2` | `#FFECD5` | `#2A1A1A` |
| `--text` | `#1A0A05` | `#FFF5EB` |
| `--text-muted` | `#9C7050` | `#B08060` |
| `--border` | `#FFE0C0` | `rgba(244,121,32,0.1)` |

---

## 2. TAILWIND @theme TEMPLATE (Copy-Paste Ready)

Pick a theme above, paste this into `style.css`:

```css
@theme {
  /* Primary Scale — REPLACE with theme values */
  --color-primary-50: #fef2f2;
  --color-primary-100: #fee2e2;
  --color-primary-200: #fecaca;
  --color-primary-300: #f87171;
  --color-primary-400: #ef4444;
  --color-primary-500: #dc2626;   /* --primary-light */
  --color-primary-600: #b91c1c;   /* --primary */
  --color-primary-700: #991b1b;   /* --primary-dark */
  --color-primary-800: #7f1d1d;   /* --primary-darker */
  --color-primary-900: #601010;

  /* Accent */
  --color-accent-400: #fcd34d;    /* --accent-light */
  --color-accent-500: #f59e0b;    /* --accent */
  --color-accent-600: #d97706;    /* --accent-dark */

  /* Surface (Light mode) */
  --color-surface: #f9fafb;
  --color-surface-2: #f3f4f6;

  /* Shadows */
  --shadow-premium: 0 4px 20px rgba(0, 0, 0, 0.08);
  --shadow-float: 0 8px 30px rgba(0, 0, 0, 0.12);
}
```

---

## 3. BUTTON LIBRARY (20 Variants)

Copy-paste any button. Replace `primary-600` with your theme's primary.
AI: Auto-add new button designs when discovered in projects or inspiration sites.

### GROUP A — Solid Buttons

```html

<button class="bg-primary-600 text-white px-6 py-3 rounded-xl font-bold active:scale-[0.97] transition-all">
  按钮文字
</button>

<button class="w-full h-14 bg-primary-600 text-white rounded-2xl font-black text-sm tracking-[0.2em] uppercase shadow-lg shadow-primary-600/20 active:scale-[0.97] transition-all">
  立即提交
</button>

<button class="bg-primary-600 text-white px-4 py-1.5 rounded-full text-[11px] font-bold active:scale-95 transition-all">
  查看详情
</button>

<button class="bg-gradient-to-r from-primary-500 to-primary-700 text-white px-6 py-3 rounded-xl font-bold shadow-lg shadow-primary-600/25 active:scale-[0.97] transition-all">
  渐变按钮
</button>

<button class="bg-primary-600 text-white px-6 py-3 rounded-xl font-bold flex items-center justify-center gap-2 active:scale-[0.97] transition-all">
  <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14"/><path d="m12 5 7 7-7 7"/></svg>
  下一步
</button>
```

### GROUP B — Outline / Ghost Buttons

```html

<button class="border-2 border-primary-600 text-primary-600 px-6 py-3 rounded-xl font-bold hover:bg-primary-600 hover:text-white active:scale-[0.97] transition-all">
  取消
</button>

<button class="text-primary-600 font-black text-[11px] uppercase tracking-widest hover:underline underline-offset-4 transition-all">
  查看更多
</button>

<button class="border border-gray-200 text-gray-600 px-4 py-2 rounded-full text-[11px] font-bold hover:border-primary-500 hover:text-primary-600 transition-all">
  筛选
</button>

<button class="w-full h-14 border-2 border-gray-100 text-gray-500 rounded-2xl font-black text-xs uppercase tracking-widest hover:bg-gray-50 active:scale-95 transition-all">
  返回
</button>
```

### GROUP C — Special / Premium Buttons

```html

<button class="bg-[#25D366] text-white px-6 py-3 rounded-xl font-bold flex items-center justify-center gap-2 shadow-lg shadow-green-500/20 active:scale-[0.97] transition-all">
  <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="white"><path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347z"/></svg>
  WhatsApp 联系
</button>

<button class="bg-white/10 backdrop-blur-md text-white px-6 py-3 rounded-xl font-bold border border-white/20 hover:bg-white/20 active:scale-[0.97] transition-all">
  探索更多
</button>

<button class="bg-red-500 text-white px-6 py-3 rounded-xl font-bold shadow-lg shadow-red-500/20 active:scale-95 transition-all">
  删除
</button>

<button class="bg-emerald-500 text-white px-6 py-3 rounded-xl font-bold shadow-lg shadow-emerald-500/20 active:scale-95 transition-all">
  确认
</button>

<button class="bg-gray-900 text-white px-6 py-3 rounded-xl font-bold shadow-xl active:scale-[0.97] transition-all">
  开始使用
</button>

<button class="bg-accent-500 text-white px-8 py-4 rounded-2xl font-black text-sm tracking-wider shadow-lg shadow-accent-500/25 active:scale-[0.97] transition-all">
  立即购买
</button>
```

### GROUP D — Icon-Only / Floating Buttons

```html

<button class="w-10 h-10 rounded-full bg-primary-50 text-primary-600 flex items-center justify-center active:scale-90 transition-all">
  <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="m15 18-6-6 6-6"/></svg>
</button>

<button class="w-10 h-10 rounded-xl bg-gray-50 text-gray-400 flex items-center justify-center border border-gray-100 hover:bg-gray-100 active:scale-90 transition-all">
  <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M3 6h18"/><path d="M19 6v14c0 1-1 2-2 2H7c-1 0-2-1-2-2V6"/></svg>
</button>

<button class="fixed bottom-6 right-6 w-14 h-14 rounded-full bg-primary-600 text-white flex items-center justify-center shadow-2xl shadow-primary-600/30 active:scale-90 transition-all z-50">
  <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
</button>

<div class="flex items-center bg-gray-50 rounded-xl p-0.5">
  <button class="w-8 h-8 flex items-center justify-center rounded-lg bg-white text-gray-400 active:scale-90 transition-all shadow-sm">
    <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><line x1="5" y1="12" x2="19" y2="12"/></svg>
  </button>
  <span class="w-8 text-center text-sm font-black">1</span>
  <button class="w-8 h-8 flex items-center justify-center rounded-lg bg-white text-gray-800 active:scale-90 transition-all shadow-sm">
    <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
  </button>
</div>
```

---

## 4. HOW AI USES THIS FILE

### Picking a Theme
```
1. User starts new project → AI checks client DNA for brand color
2. Match brand color to closest theme (A-E)
3. Copy the @theme template → paste into style.css
4. Replace hex values with matched theme
5. All buttons + components auto-inherit the theme via Tailwind tokens
```

### Picking Buttons
```
1. Need a CTA? → A2 (Large Primary) or C6 (Accent Gold)
2. Need cancel/secondary? → B1 (Outline) or B4 (Outline Large)
3. Need WhatsApp? → C1 (always this one, S-CORE)
4. Need delete? → C3 (Danger)
5. Need quantity stepper? → D4 (Stepper)
6. Need floating action? → D3 (FAB)
7. Need glassmorphism on dark bg? → C2 (Glass)
```

### Adding New Buttons
When AI discovers a new button design (from Awwwards, Mobbin, user approval):
```
1. Save the HTML to the matching GROUP (A/B/C/D)
2. Add comment with source project and score
3. Increment button count in this section header
```

---

## 5. PRE-BUILT CARD COMPONENTS (Theme-Aware)

These cards automatically adapt to whichever theme is active via `primary-600`, `bg-surface`, etc.

### Stats Card (Dashboard)
```html
<div class="bg-white p-5 rounded-3xl shadow-premium border border-gray-50">
  <div class="w-10 h-10 bg-primary-50 rounded-xl flex items-center justify-center text-primary-600 mb-4">
    
  </div>
  <p class="text-2xl font-black text-gray-800">RM 1,280</p>
  <p class="text-[10px] font-black text-gray-400 uppercase tracking-widest mt-1">今日营收</p>
</div>
```

### Menu Item Row (Profile/Settings)
```html
<button class="w-full flex items-center justify-between p-4 hover:bg-gray-50 rounded-xl transition-all cursor-pointer">
  <div class="flex items-center gap-4 text-gray-800">
    <div class="w-10 h-10 bg-primary-50 rounded-xl flex items-center justify-center text-primary-600">
      
    </div>
    <span class="text-sm font-black tracking-tight">菜单项目</span>
  </div>
  <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#D1D5DB" stroke-width="2"><path d="m9 18 6-6-6-6"/></svg>
</button>
```

### Empty State
```html
<div class="flex flex-col items-center justify-center min-h-[60vh] px-10 text-center">
  <div class="w-24 h-24 bg-gray-50 rounded-[32px] flex items-center justify-center mb-8 text-gray-200">
    
  </div>
  <h3 class="text-xl font-black text-gray-800 mb-2">暂无数据</h3>
  <p class="text-[11px] text-gray-400 font-bold uppercase tracking-widest mb-10 leading-relaxed">描述文字</p>
  <a href="/action" class="bg-primary-600 text-white px-14 py-4 rounded-xl font-bold active:scale-[0.97] transition-all">
    行动按钮
  </a>
</div>
```

### Page Header Banner (Gradient)
```html
<div class="bg-gradient-to-br from-primary-600 via-primary-700 to-primary-900 text-white px-6 pt-8 pb-14 relative overflow-hidden">
  <div class="absolute top-0 right-0 w-40 h-40 bg-white/5 rounded-full -mr-14 -mt-14"></div>
  <div class="absolute bottom-0 left-0 w-28 h-28 bg-white/5 rounded-full -ml-10 -mb-10"></div>
  <div class="relative z-10">
    <h2 class="text-2xl font-black tracking-tight mb-1">页面标题</h2>
    <p class="text-[11px] font-bold text-white/50 uppercase tracking-widest">SUBTITLE</p>
  </div>
</div>
```

---

Theme System V1.0 — 5 Themes × Light/Dark + 20 Buttons + 4 Cards — Created 2026-03-19
AI: Auto-expand when new themes, buttons, or components are discovered

