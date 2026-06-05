---
name: industrial-interaction-library
description: "Sovereign Industrial Patterns & Interaction Library (V2.0)"
triggers: ["industrial patterns", "ui patterns", "stitch ui", "mobile popup", "modal", "sidebar"]
version: 2.0
status: authoritative
---

# 🏗️ INDUSTRIAL INTERACTION LIBRARY (V2.0)

This master file consolidates industrial UX patterns, UI patterns, Stitch UI protocols, and the mobile popup/modal recipe.

# === INDUSTRIAL_PATTERNS.md ===
# Sovereign Industrial UX Patterns

This document defines the high-level UX and interaction patterns unique to the **Sovereign Web Framework (SWF)** as used in the quizLaa project.

## 📐 Pattern: The Top-Down Relationship Tray
This pattern provides an "unobtrusive reveal" of relational data without navigating away from the core list.

### 1. Interaction Model
- **Trigger A (General)**: Clicking the `lucide:layers` header icon (Layericon). Opens the tray with **Tabs** for all available relationships (e.g., Reviews, Leads).
- **Trigger B (Specific)**: Clicking a blue count link in a record (e.g., "5 Reviews"). Opens the tray in **Full-Bleed Single Mode** (specifically targeting that relationship).

### 2. Implementation Specs
- **Component**: `RelationshipDrawer.vue` (top-placement).
- **Embedded Tables**: Use the list components (e.g., `ReviewList`) with the `embedded` prop set to `true`. This removes external padding and full-page height controls. [FE:Step 09]
- **Header Aesthetic**: Uses `cinematic-gradient-header` for a premium, darkened visual break.
- **Drawer Placement**: `placement="top"`. Height should be roughly `600px` to `800px` depending on data density.

## 📐 Pattern: Relationship Navigation Hierarchy
Standardized mapping for M2M and 1:N navigation.

| Direction | Mechanism | Implementation | Referral |
|---|---|---|---|
| **UP** (to Parent) | **CellFkLink** | Blue clickable text in List columns. | `[FE:Step 09]` |
| **DOWN** (to Child) | **Layericon** | `lucide:layers` action button in List rows. | `[FE:Step 11]` |

## 📐 Pattern: Sovereign Data Specification (Malaysian)
All seed, mock, and test data MUST strictly follow Malaysian regional standards. [FE:Step 02]

- **Companies**: Must end in `Sdn Bhd` or `Bhd`.
- **Phones**: Format `+60 12-345 6789`.
- **Emails**: Use `.com.my` or `.my` domains where applicable.
- **Geography**: Utilize Malaysian cities (Kuala Lumpur, Penang, Johor Bahru).

## 📐 Pattern: The Profile-Only Detail
This pattern allows viewing an entity's core details (Profile) without the noise of its relationship tables, typically used when navigating *from* a relationship page (e.g., from a Lead to the Agent's profile). [FE:Step 09]

### Implementation Specs
- **Prop**: `hideTables: true`.
- **Navigation**: The `DetailDrawer` must check for this prop in `setData` and pass it to the underlying `Detail` component.

---
**Status**: Authoritative | **Last Update**: 2026-04-21 | **Domain**: UX / Interaction Design

# === SOVEREIGN_UI_PATTERNS.md ===
---
name: sovereign-ui-patterns
description: "Sovereign 设计模式 (V1.0)"
triggers: ["design", "patterns", "views", "filters", "chips", "status"]
version: 1.0
status: authoritative
---

# 第二部分 通用设计模式 (Sovereign Design Patterns)

本文件定义了 Views 中常用的交互模式，确保系统的视觉一致性和操作流畅度。

## 一、 水平状态标签 (Horizontal Status Chips)
*   **说明**: 用于列表顶部的分类过滤，支持横向滑动，带有缩放和发光效果。
*   **代码示例**:

```html
<!-- 使用 no-scrollbar 类隐藏滚动条 -->
<div class="flex gap-2 overflow-x-auto no-scrollbar p-4 pb-2">
  <button v-for="(cfg, key) in statusConfig" :key="key" :class="[
    'shrink-0 px-4 py-2 rounded-full border transition-all duration-300 flex items-center gap-2 shadow-sm text-[11px] font-bold',
    activeFilters.includes(key)
      ? 'bg-slate-900 border-slate-900 text-white scale-105 ring-2 ring-slate-900/10'
      : 'bg-white border-gray-200 text-slate-600 hover:border-gray-400'
  ]">
    <span class="size-1.5 rounded-full" :style="`background-color: ${cfg.color}`"></span>
    {{ cfg.label }}
  </button>
</div>
```

## 二、 状态条卡片 (Status Strip Card)
*   **说明**: 通过左侧的彩色条快速传达数据状态，适用于仪表盘和精简列表。
*   **代码示例**:

```html
<div class="bg-white rounded-2xl border border-gray-100 flex overflow-hidden shadow-sm active:scale-[0.98] transition-all duration-300">
  <!-- 根据状态绑定的颜色条 (GYOR 逻辑) -->
  <div class="w-1.5 shrink-0" :style="`background-color: ${statusColor}`"></div>
  
  <div class="flex-1 p-4">
    <!-- 内容区域 -->
    <div class="flex justify-between items-start">
      <h3 class="font-bold text-slate-900">{{ title }}</h3>
      <span :class="['px-2 py-0.5 rounded-md text-[9px] font-black', statusBg, statusText]">
        {{ statusLabel }}
      </span>
    </div>
  </div>
</div>
```

---
## 三、 相关链接 (Related Links)
*   **参考**: [MASTER_BLUEPRINT.md](../0_apex/templates/MASTER_BLUEPRINT.md)

---
*Created by Antigravity Tier-1 Core Design Node*


---

# === STITCH_UI_PROTOCOL.md ===
# 🧵 Sovereign Stitch UI Protocol (V3.1)

这是本项目的核心视觉协议，AI 在生成任何 UI 时必须强制调用。

## 🎨 1. 核心配色方案 (The Palette)

- **Deep Forest (底色)**: `#0d1a14` (通透深绿)
- **Neon Lime (核心色)**: `#b8f132` (高发光黄绿)
- **Sage Ink (柔和白)**: `rgba(224, 231, 225, 0.9)` (杜绝纯白)

## 💎 2. 组件基准 (Stitch Components)

### 2.1 `stitch-card` (玻璃贴片)

- **圆角**: `32px`
- **背景**: `white/4` + `backdrop-blur-3xl`
- **边框**: `white/5` 或 `theme-500/10` (极细)
- **阴影**: 组合阴影 (外部深阴影 + 内部微发光)

### 2.2 `stitch-btn-primary` (荧光按钮)

- **圆角**: `20px`
- **点击感**: `active:scale-95` + `transition-all 500ms`
- **发光**: 按钮下方必须带有 `theme-500/20` 的扩散阴影。

## 🌌 3. 环境光影 (Atmosphere)

- **Radial Glow**: 页面顶部必须有一个 `theme-500/12` 的径向渐变，模拟顶光。
- **Micro-Interactions**: 所有悬浮状态 (Hover) 必须通过 `border-opacity` 或 `bg-opacity` 的微增来体现，而非剧烈的颜色变化。

## 📡 4. 地图指挥准则 (Map HUD)

- **Marker**: 必须使用三层光晕点位 (Core + Glow + Outer Blur)。
- **Panel**: 底部统计面板必须使用 `stitch-card` 结构并支持折叠。

---

## 🤖 5. AI 设计联动 (AI Orchestration)

- **StitchMCP Integration**: 在生成代码前，AI 必须查询 `StitchMCP` 以获取最新的工业级视觉参数、微动画规格和响应式布局优化方案。
- **Maximum Customization**: 利用 `StitchMCP` 提供的变量系统，实现最高自由度的 UI 自定义，确保每个页面都有其独特的“呼吸感”。

## 🔒 6. 稳健设计准则 (Conservative Design Principles)

- **严禁越权修改 (Strict Scope Control)**: AI 在处理用户请求时，**严禁** 主动、越权修改未被提及的设计配置（如全局主题色、字体、核心圆角等）。
- **设计冻结 (Design Freeze)**: 除非用户明确授权（例如使用 "自由发挥"、"free to change anything"、"AI 可以做任何优化" 等宽松指令），否则 AI 必须严格遵守现有的视觉规范，不得随意抽取改动并污染全局。
- **安全隔离**: 在新增组件时，优先继承局部样式，避免破坏现有色彩树。

---

_Created by Antigravity // Tier-0 Governance V3.1_

# === MOBILE_POPUP_MODAL_SIDEBAR.md ===
# Mobile Popup-Modal Sidebar from a Hamburger Button

**Date solved:** 2026-04-22
**Context:** `alexis` project, `template/rbz-download.php`. User had tried to build this pattern
several times in `.codex` and failed; this is the working recipe.

---

## 1. What the user asked for (their vocabulary)

> "rbz-download pages — when user click `.mobile-menu-toggle`, `.dashboard-sidebar` this will
> become a popup modal display showing to user."
>
> Follow-ups:
> - "are you sure i press the mobile-menu-toggle the dashboard-sidebar wont show or should
>   update the css to position absolute?"
> - "Uncaught ReferenceError: $ is not defined"
> - "add some fadein fadeout animation"

Translated requirements:
1. Below the `991px` breakpoint, the sidebar must stop being an inline panel and become
   a **centered popup modal** with a dimmed backdrop.
2. Desktop layout (sticky sidebar inside a flex wrapper) must stay untouched.
3. Works with vanilla JS — no jQuery on the page.
4. Fade-in / fade-out animation, not an instant show/hide.

---

## 2. Why earlier attempts failed (the three traps)

These are the traps that broke it for the user before. Every reusable implementation must
defend against all three.

### Trap A — `position: fixed` silently broken by an ancestor

If **any** ancestor has `transform`, `filter`, `perspective`, `will-change`, `contain`, or
`backdrop-filter`, that ancestor becomes the containing block for `position: fixed`
descendants. The modal then anchors to that ancestor instead of the viewport, often
rendering far offscreen or not at all.

Compiled CSS bundles (`main.*.css`) and libraries like AOS routinely introduce transforms
on ancestors. **You cannot rely on auditing the ancestor chain.**

> **Fix:** On open, detach the modal + backdrop and `appendChild` them to `<body>`.
> On close, return them to their original parents after the transition completes.

### Trap B — `$ is not defined`

Template sites from free HTML packs often **don't ship jQuery** in the final bundle, even
though the tutorial uses `$`. `alexis/assets/js/main.js` is a 15KB vanilla-JS IIFE.
Always check the author of the bundle before writing `$(...)`.

> **Fix:** Write the modal script in vanilla JS. Guard any optional jQuery plugin calls
> (isotope, slick, etc.) behind `if (window.jQuery)`.

### Trap C — `display: none → block` kills the CSS transition

CSS transitions do not animate the `display` property. Switching from `display: none` to
`display: block` makes the browser skip the transition — the modal just pops in.

> **Fix:** Use `visibility: hidden` + `pointer-events: none` + `opacity: 0` for the
> closed state, and transition `opacity`, `transform`, and `visibility` (with a delay
> on close so `visibility` flips *after* the fade completes).

---

## 3. The working recipe

### 3.1 HTML — add a backdrop sibling

Place the backdrop as a sibling of the sidebar (or anywhere in the page — it will be
moved to `<body>` on open anyway).

```html
<div class="mobile-dashboard-nav mb-30">
    <div class="nav-label"><i class="icon_tag_alt"></i> MENU</div>
    <button class="mobile-menu-toggle" id="mobileDashToggle">
        <i class="icon_menu"></i>
    </button>
</div>

<!-- Backdrop lives outside .dashboard-wrapper -->
<div class="sidebar-backdrop" id="sidebarBackdrop"></div>

<div class="dashboard-wrapper">
    <aside class="dashboard-sidebar" id="dashboardSidebar">
        <!-- sidebar content: search, category filters, etc. -->
    </aside>
    <div class="dashboard-content"><!-- grid --></div>
</div>
```

### 3.2 CSS — mobile-only modal rules

Scoped inside `@media (max-width: 991px)` so desktop is unaffected.

```css
@media (max-width: 991px) {
    /* Keep display:block; use visibility+opacity so transitions work */
    .dashboard-sidebar {
        display: block !important;
        visibility: hidden;
        pointer-events: none;
        position: fixed !important;
        top: 50% !important;
        left: 50% !important;
        transform: translate(-50%, -55%) scale(0.92) !important;
        width: calc(100% - 40px) !important;
        max-width: 440px !important;
        max-height: 85vh !important;
        overflow-y: auto !important;
        flex: none !important;
        z-index: 100001 !important;
        box-shadow: 0 25px 60px rgba(0,0,0,0.35) !important;
        background-color: var(--dashboard-surface) !important;
        border: 1px solid var(--dashboard-border) !important;
        border-radius: 16px !important;
        padding: 30px 25px !important;
        opacity: 0;
        transition:
            opacity 0.3s ease,
            transform 0.4s cubic-bezier(0.34, 1.5, 0.64, 1),
            visibility 0s linear 0.3s;
    }

    /* Extra safety when the sidebar has been detached to <body> */
    body > .dashboard-sidebar:not(.active) {
        visibility: hidden !important;
    }

    .dashboard-sidebar.active,
    body > .dashboard-sidebar.active {
        visibility: visible;
        pointer-events: auto;
        opacity: 1 !important;
        transform: translate(-50%, -50%) scale(1) !important;
        transition:
            opacity 0.3s ease,
            transform 0.4s cubic-bezier(0.34, 1.5, 0.64, 1),
            visibility 0s linear 0s;
    }

    .sidebar-backdrop {
        display: block !important;
        visibility: hidden;
        pointer-events: none;
        position: fixed !important;
        top: 0 !important;
        left: 0 !important;
        width: 100vw !important;
        height: 100vh !important;
        background: rgba(0, 0, 0, 0.6) !important;
        -webkit-backdrop-filter: blur(4px);
        backdrop-filter: blur(4px);
        z-index: 100000 !important;
        opacity: 0;
        transition:
            opacity 0.3s ease,
            visibility 0s linear 0.3s;
    }

    .sidebar-backdrop.active,
    body > .sidebar-backdrop.active {
        visibility: visible;
        pointer-events: auto;
        opacity: 1 !important;
        transition:
            opacity 0.3s ease,
            visibility 0s linear 0s;
    }

    body.sidebar-modal-open {
        overflow: hidden !important;
    }
}
```

Key CSS points:
- Every modal property uses `!important` to beat compiled bundle overrides.
- The `body > .modal.active` selector is an extra-specificity fallback for when the
  element has been moved under `<body>`.
- Starting transform is `translate(-50%, -55%) scale(0.92)` — the subtle upward drift
  and slight scale give a premium pop-in instead of a flat fade.
- `cubic-bezier(0.34, 1.5, 0.64, 1)` is a gentle overshoot spring.
- `visibility 0s linear 0.3s` on close keeps the element visible during the fade, then
  flips it to hidden exactly when the opacity transition finishes.

### 3.3 JS — vanilla, with the body-append trick

```html
<script>
(function () {
    function ready(fn) {
        if (document.readyState !== 'loading') fn();
        else document.addEventListener('DOMContentLoaded', fn);
    }

    ready(function () {
        var sidebar  = document.getElementById('dashboardSidebar');
        var backdrop = document.getElementById('sidebarBackdrop');
        var toggleBtn = document.getElementById('mobileDashToggle');
        if (!sidebar || !backdrop || !toggleBtn) return;

        var sidebarHome  = sidebar.parentNode;
        var backdropHome = backdrop.parentNode;
        var toggleIcon   = toggleBtn.querySelector('i');

        function openModal() {
            document.body.appendChild(sidebar);
            document.body.appendChild(backdrop);
            // Force reflow — commits the "closed" state before .active flips it,
            // so the browser actually runs the transition.
            void sidebar.offsetHeight;
            sidebar.classList.add('active');
            backdrop.classList.add('active');
            document.body.classList.add('sidebar-modal-open');
            if (toggleIcon) {
                toggleIcon.classList.add('icon_close');
                toggleIcon.classList.remove('icon_menu');
            }
        }

        function closeModal() {
            sidebar.classList.remove('active');
            backdrop.classList.remove('active');
            document.body.classList.remove('sidebar-modal-open');
            if (toggleIcon) {
                toggleIcon.classList.add('icon_menu');
                toggleIcon.classList.remove('icon_close');
            }
            // Return to original parents AFTER the longest transition (400ms).
            setTimeout(function () {
                if (!sidebar.classList.contains('active')) {
                    sidebarHome.appendChild(sidebar);
                    backdropHome.appendChild(backdrop);
                }
            }, 420);
        }

        toggleBtn.addEventListener('click', function () {
            if (sidebar.classList.contains('active')) closeModal();
            else openModal();
        });

        backdrop.addEventListener('click', closeModal);

        // Close when any sidebar menu item is clicked (filters, links, etc.)
        sidebar.querySelectorAll('.sidebar-menu-item').forEach(function (btn) {
            btn.addEventListener('click', closeModal);
        });

        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape' && sidebar.classList.contains('active')) {
                closeModal();
            }
        });
    });
})();
</script>
```

Key JS points:
- `void sidebar.offsetHeight` **after** moving the element, **before** adding `.active`.
  Without this forced reflow the browser batches the append + class change and skips
  the transition.
- Close-timeout **must match or exceed** the longest CSS transition duration. We use
  420ms here because the transform is 400ms.
- The close check (`if (!sidebar.classList.contains('active'))`) guards against the
  user rapidly reopening during the fade-out — we don't want to move the element back
  home while it's being shown again.

---

## 4. Reusability checklist

When porting this pattern to another page or project:

- [ ] The sidebar has a unique `id` (for JS grabbing).
- [ ] A backdrop div with its own `id` is in the markup.
- [ ] The trigger button has an `id` and contains an `<i>` for the icon swap.
- [ ] Modal CSS lives inside `@media (max-width: 991px)` (or your mobile breakpoint).
- [ ] Every modal property carries `!important`.
- [ ] `z-index` is high enough to beat stickies/headers (100000+).
- [ ] JS appends sidebar + backdrop to `<body>` on open.
- [ ] JS forces a reflow before adding `.active`.
- [ ] JS return-to-home `setTimeout` duration ≥ longest CSS transition.
- [ ] Backdrop click, Escape, and menu-item click all call `closeModal()`.
- [ ] `body.sidebar-modal-open { overflow: hidden }` locks background scroll.
- [ ] Before using `$(...)`, confirm jQuery is actually loaded on the page.

---

## 5. Quick-reference: the three fixes, named

| Name                 | What it solves                                          | Where it lives            |
|----------------------|---------------------------------------------------------|---------------------------|
| **Body-Append Trick** | Defeats any ancestor transform/filter breaking `fixed`  | JS `openModal()`         |
| **Vanilla Port**      | Site has no jQuery — no `$ is not defined`             | JS IIFE + `ready()`       |
| **Visibility Swap**   | `display` flipping skips transitions — use visibility   | CSS closed/active states  |

These three together are the difference between "the modal pops in instantly" /
"the modal doesn't appear at all" / "crash on page load" and a smooth, reliable
fade-in popup.
