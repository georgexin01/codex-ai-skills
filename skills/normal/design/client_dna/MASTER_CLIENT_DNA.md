# MASTER CLIENT DNA VAULT (V15.2 APEX)
# [⚡ MODE: APOLLO] | [🧬 STATUS: ACTIVE]

---
---
name: 86car-design-dna
description: "86caraccessories.my — Design DNA & E-Commerce Logic"
triggers: ["86car design dna", "86car_design_dna", "86caraccessories design commerce"]
phase: reference
model_hint: gpt-5.3-codex
version: 42.0
_ohdy_wrapper: |-
  # OHDY COMPRESSED NODE (V42.0)
  <dna_node>
  v: 42.0
  n: 86car_design_dna
  graph:
    req: []
    rel: []
  l: |-
  </dna_node>
---

# 86caraccessories.my — Design DNA & E-Commerce Logic

## 1. Overview
`86caraccessories.my` (branded as Ninety Six / 96 Car Accessories) is a gold-standard reference for product-heavy e-commerce and booking applications. Its architecture is optimized for high category visibility and rapid visual scanning.

## 2. Structural DNA: Sidebar-First Layout
This layout is 100% approved for projects requiring product ordering, booking, or merchandise sales (e.g., `hh-tyres-app`).

- Architecture: Two-Column Fixed Sidebar.
- Left Column (Sidebar):
  - Width: ~80px to 120px.
  - Content: Vertical icon-based category menu.
  - Behavior: Fixed. Categories stay visible while products scroll.
  - Active State: Highlighted with Primary Accent (`#800000`).
- Right Column (Main):
  - Content: Product grid grouped by category headers.
  - Grid: 2-column (Mobile) or 3-4 column (Web).
  - Cards: High-impact imagery, bold maroon titles, and prominent pricing.

## 3. Visual DNA: Tactical Maroon
- Primary Color: Deep Maroon / Crimson (`#800000`). Used for titles, prices, and active states.
- Background: Clean White (`#FFFFFF`).
- Typography: Geometric Sans-Serif (Roboto, Montserrat, or Plus Jakarta Sans).
- Aesthetic: Clean Tech Professional. No clutter, heavy focus on product utility.

## 4. History & Legacy
- Brand: Ninety Six (96) Car Accessories.
- Context: Rooted in Malaysian automotive parts and services since ~2011.
- Evolution: Transitioned from physical service centers to high-density digital catalogs.
- Fingerprint: FP-006 (E-Commerce Standard).

## 5. Usage in V11
- Standard: For all "E-Commerce", "Booking", or "Product Selling" missions.
- Implementation: Start with `SidebarCategoryNav.vue` + `ProductGrid.vue`.

---
*Generated: 2026-03-20 | V11 Design Vault*


---
---
name: golden-shop-design-dna
description: "🦢 Golden Shop Design DNA (Heritage Cyber-Luxury)"
triggers: ["golden shop design dna", "golden_shop_design_dna", "golden shop design"]
phase: reference
model_hint: gpt-5.3-codex
version: 42.0
_ohdy_wrapper: |-
  # OHDY COMPRESSED NODE (V42.0)
  <dna_node>
  v: 42.0
  n: golden_shop_design_dna
  graph:
    req: []
    rel: []
  l: |-
  </dna_node>
---

# 🦢 Golden Shop Design DNA (Heritage Cyber-Luxury)

V1.0 — 2026-03-31
Style Category: Traditional Chinese Heritage x Modern Dark-Mode Glassmorphism
Purpose: Template for high-end boutique apps and "Cyber Luxury" Chinese brands.

---

## 🎨 1. Color Palette & Visual Identity

| Token | Value | Role |
|---|---|---|
| Heritage Red | `#C1272D` (`cal-red-strong`) | Primary UI, Borders, Emphasis |
| Golden Accent | `#D4AF37` | Premium Dividers, Icons, Level 1 Badges |
| Cyber Dark | `#1A1A1A` (`brand-dark`) | Backgrounds, Primary Headers |
| Bone White | `#FDF5E6` | High-contrast text on Red, Background Cards |
| Accessible Slate | `slate-500` | Secondary metadata (Deepened from 400 for contrast) |

### Visual Stamps
- Double-Border Seals: `border-4 border-double border-cal-red-strong` for critical sections.
- Inner Shadows: Use `shadow-inner` on background containers to create depth.
- Glassmorphism: `backdrop-blur-md bg-white/30` for floating elements.

---

## 🖋️ 2. Typography System
- Master Header: `font-family: 'Noto Serif SC', serif; font-weight: 900; font-style: italic; letter-spacing: tracking-widest;`
- Component Headers: `text-brand-dark font-black tracking-wider`.
- Metadata: `text-[10px] uppercase tracking-tighter`.

---

## 🧩 3. Component Blueprints

### A. Genealogy Node (Referral Tree)
- Structure: Recursive `ReferralTreeNode` with vertical and horizontal connector lines.
- Style: Circular avatar frame (`w-50 h-50 rounded-full border-3 shadow-md`).
- Logic: Use `chunkedReferrals` (max 4 per row) for mobile-first readability.
- Vertical Connectors: Absolute `border-l border-[#D4AF37]/60` for the central trunk.

### B. Singleton Tooltip Flow
- Pattern: Centralized `activeTooltipId` in the parent component.
- Rule: Only ONE tooltip at a time.
- Mechanism: Global `click` listener that clears the ID if target is not a `.referral-node-card`.
- UI: Border-less shadow-popover with `z-100` priority.

### C. Heritage Confirmation Modals
- Pattern: `<Teleport to="body">` for absolute z-index authority.
- UI: Dark blurred backdrop (`bg-black/60`), centered heritage-themed card, red icon for danger.

---

## ⚖️ 4. Business Logic Patterns

### Point & Redemption
- Conversion: `RM 1 = 10 Points` (or vice-versa depending on project settings).
- Tiers: Standardized redemption blocks: RM 10, 20, 30, 50, 100.
- Guards: Auto-disable/grayscale redemption buttons if user balance is insufficient.

### Shipping & Logic
- WM/EM Split: Different free shipping thresholds for West/East Malaysia.
- Assurance Section: Explicit "Golden Assurance" cards explaining authenticity and shipping policies to build trust.

---

## 🛠️ 5. Infrastructure DNA
- Apache/cPanel Strategy:
    - `.htaccess` must include `Cache-Control: no-cache, no-store, must-revalidate` for `index.html`.
    - Assets (`js`/`css`) use `max-age=31536000, immutable` for performance.
- SPA Redirection: Standard 404-to-index rewrite logic (Gate 3.2 compliance).

---

## 🧬 6. User Preference Fingerprint
- Preference: Zero-placeholder policy (All content must be "real-world" density).
- Standard: "Golden Planning Protocol" (Deep thinking -> Plan -> User approval).
- Radius: `rounded-[24px]` (Sharper modern heritage).

Extracted from Golden Shop App Production Cycle 2026Q1


---
---
name: japanese-food-app-design
description: "Japanese Food App UI/UX Design Mastery"
triggers: ["japanese food app design", "japanese_food_app_design", "japanese food design"]
phase: reference
model_hint: gpt-5.3-codex
version: 42.0
_ohdy_wrapper: |-
  # OHDY COMPRESSED NODE (V42.0)
  <dna_node>
  v: 42.0
  n: japanese_food_app_design
  graph:
    req: []
    rel: []
  l: |-
  </dna_node>
---

# Japanese Food App UI/UX Design Mastery

## 核心设计理念 (Core Design Philosophy)

日本的餐饮应用（如点餐、外卖服务）在全球范围内以其对细节的极致追求、用户体感的极高度重视以及将“枯燥的工具”转化为“有趣的体验”而闻名。核心理念可以用三个词概括：高信息密度但有序、视觉驱动食欲、游戏化提升留存（Gamification）。

## 3个典型日本点餐 App/Web 分析

### 1. Menu (本地新兴外卖平台)

设计理念： 现代化、年轻化与游戏化（Gamification）。
构造排列：

- 全屏视觉冲击： 摒弃传统的文字列表，采用大尺寸、高清晰度的无背景美食图片作为主视觉。
- 卡片式抽屉布局： 底部抽屉式交互（Bottom Sheets）顺滑，单手操作体验极佳。
  用户体验与有用启发：
- Gacha（扭蛋）机制： 这是Menu最成功的UX之一。用户下单或留下带图好评可以获得扭蛋代币，抽取限定周边或优惠券。将“点外卖”变成了“玩游戏”，极大地提高了留存率。
- 微交互（Micro-interactions）： 添加购物车时的飞入动画、加载时的趣味UI，缓解了用户等待的焦虑感。
- 应用到后续生成： 在生成应用时，可考虑加入类似的“进度条”、“成就勋章”或“盲盒/抽奖”等游戏化UI组件来提高用户获取感。

### 2. 出前馆 (Demae-can - 日本国民级外卖平台)

设计理念： 信任感、高效转化与本土化布局。
构造排列：

- 高密度分类网格（Grid Navigation）： 首页上方密集的Icon分类（寿司、拉面、便当等），契合日本用户习惯的高信息密度阅读。
- 优惠前置（Coupon First）： 头图轮播或流动横幅永远是当前最优惠的活动。
  用户体验与有用启发：
- 确定性与透明度： 每一个店铺列表极其显眼地标注了“配送时间（如15-20分）”和“配送费”，并用不同颜色高亮。
- 本地化色彩心理学： 大量使用能够引发食欲的暖色调（主色调为红色），按钮状态极其清晰（Active/Disabled）。
- 应用到后续生成： 在设计UI时，必须保证价格、时间、优惠信息的层级最高且最易读；利用色彩心理学（红/黄）刺激购买欲。

### 3. くら寿司 (Kura Sushi / 官方App)

设计理念： 全渠道融合（Omnichannel）与家庭化、趣味化交互。
构造排列：

- 清晰的操作区块（Chunky UI）： 考虑到多年龄层用户，按钮设计巨大，色彩对比强烈，多使用带有圆角的直观扁平化设计。
- 堂食与外带的无缝切换： 首页最显眼的两个入口清晰划分“预约堂食”和“外带下单”，路径极短。
  用户体验与有用启发：
- Bikkura Pon (扭蛋系统) 数字化： 店里吃5盘寿司抽一次扭蛋的经典玩法被移植到App中，线上点餐也能积攒“盘数”参与抽奖。
- 传送带般的选餐： 选购视觉像在真实的传送带上拿取一样直观。
- 应用到后续生成： 强调UI的“亲和力（Affinity）”，多使用圆角（`Border-radius: 12px ~ 16px`），使用柔和而明亮的色彩以及柔和的极淡阴影。

---

## 💡 AI Agent 下次生成应用的落地指南 (Actionable Guidelines for Next Generation)

当随后的时间为您生成 Web 或 App 时，我将自动回想并应用此知识库中的以下规则：

1. 色彩与质感 (Color & Texture)
   - 使用暖色调(红、橙、亮黄)作为核心CTA(Call to Action)按钮，刺激点击。
   - 保留充足留白（Whitespace），大背景多使用低饱和微灰色（如 `#f9fafb` 或 `#f5f7fa`），以凸显前方亮亮的美食图片。

2. 排版与组件 (Typography & Components)
   - 大图卡片优先： 菜品展示必须以大比例的高清图片为主，利用图片暗角叠加渐变阴影保证浮动文字可读性。
   - 圆角与软阴影 (Soft UI)： 大量使用 `border-radius: 16px` 以及柔和的 `box-shadow: 0 10px 30px rgba(0,0,0,0.06)`，营造日式精细、温和的视觉体感。
   - 高亮状态标签 (Status Badges)： 菜品图片左上角必须带有醒目的标签（如“人气No.1”、“限定”、“剩余2份”），利用清晰的信息密度促单。

3. 微交互与游戏化 (Micro-interactions & Gamification)
   - 提供良好的操作反馈（如悬停时的平滑缩放 `transform: scale(1.02)`，以及平滑过渡 `transition: all 0.3s ease`）。
   - 适时在用户主流程中嵌入诸如“连续下单挑战进度”、“积分/优惠券兑换区”等能够带来惊喜感的UI板块，打破传统工具类APP的枯燥感。


---
---
name: jin-hong-design-protocols
description: "Jin Hong M&E: Premium Corporate Design Protocol (V4)"
triggers: ["jin hong design protocols", "jin_hong_design_protocols", "hong premium corporate"]
phase: reference
model_hint: gpt-5.3-codex
version: 42.0
_ohdy_wrapper: |-
  # OHDY COMPRESSED NODE (V42.0)
  <dna_node>
  v: 42.0
  n: jin_hong_design_protocols
  graph:
    req: []
    rel: []
  l: |-
  </dna_node>
---

# Jin Hong M&E: Premium Corporate Design Protocol (V4)

Standard for Industrial High-Tech Precision Interfaces

## 1. Structural Standards (The "Modern Density" Protocol)

- 4-Column Grid Layout: Force `col-lg-3` for primary showcases (Services, Features) to ensure the interface feels "dense" and premium.
- Deep Detail Synchronization: Mandated sync of Header, Footer, and Scripts between Homepage and all interior pages (e.g., `project-details.html`).
- Main Session Wrapper: MANDATORY wrap of all mid-page content in `<div class="main-session">`.
- Layout Safety Rules:
  - `body`: Must have `padding: 0 !important;` to avoid top/bottom leaks.
  - `.footer-bottom`: Must have `padding-bottom: 30px;` (safety margin for floating elements).
  - `.main-session`: Handles the primary page-level bottom spacing (`60-90px`).

## 2. Aesthetic Evolution (Dark Tech Precision)

Avoid light foundations for high-tech industrial projects. Adhere to the "Dark + Gray + Blue" onyx palette:

1. Base Foundation: Deep Onyx (#0a0b10) for maximum contrast.
2. Surface Layer: Slate Slate (#14161f) for mid-ground elements.
3. Glassmorphism: MANDATORY Use of `.glass-panel` (backdrop-filter: blur(20px)) for all floating cards and menus.
4. Accent Glow: Electric Blue (HSL 217, 100%, 61%) used sparingly for icons, shadows, and navigation underlines.
5. Pattern Overlays: Apply low-opacity `linear-gradient` grids or masks to dark backgrounds to create "blueprint" texture.

## 3. UI Conversion Library & Animations

- Master Button Protocol: maintain `.btn-v3-` classes: Primary, Vibrant, Glass, Cyber, Soft, Outline, White, and Ghost.
- Trust Ribbon Strategy: Floating ribbon (20+ Years / 800+ Workers) immediately below Hero.
- Micro-Animations:
  - Staggered reveal delays (`.delay-1` to `.delay-4`) for grid items.
  - Floating vertical animations for high-impact trust numbers.

## 4. Engineering Standards (Conversion & Stability)

- Dark Theme Priority: All subpages must resolve to a unified dark theme; white background div-boxes are strictly prohibited in V4.
- WA Direct Hooks: All conversion buttons hook into `wa.me/` for immediate 1-to-1 industrial client response.
- Relative Path Migration: assets must be local (`images/certs/`) to ensure reliability.

## 5. Theme Visibility & Consistency Rules [NEW]

- Prohibited Contrasts: Pure white (`#fff`) or light grey (`#f8f9fa`) container backgrounds are strictly prohibited when the overall site theme is Dark/Onyx.
- Inner Div Policy: All internal session divs, cards, and modal boxes must use `var(--color-surface-base)`, `var(--color-surface-muted)`, or `.glass-panel`.
- Reasoning: To maintain the "Industrial High-Tech" visual integrity and avoid jarring visual spikes in dark mode environments.
- Save Priority: This rule is now a core part of the Jin Hong Design setting and must be enforced in all future layout expansions.

## 6. Master Tier Design Solutions (Awesome Skills Integration)

### 6.1 Micro-interactions (Design Spells)

- The "Wow" Factor: DO NOT settle for default Bootstrap/Tailwind behaviors. Use magnetic hover effects, physics-based scroll reveals, and fluid transitions to make the site feel "expensive."
- Execution: Apply `transition: all 0.6s cubic-bezier(0.16, 1, 0.3, 1)` as a baseline for premium motion.

### 6.2 Figma-Driven Accuracy

- Token Extraction: When a Figma URL is provided, prioritize extracting design tokens (colors, font-weights, spacing) via `figma-automation` to ensure 100% brand fidelity.
- Component Parity: Mirror Figma component hierarchies directly in the CSS architecture.

### 6.3 Rigorous Visual Validation

- Reverse Validation: Before claiming a UI task is done, actively look for visual flaws (misalignments, contrast issues, responsive breakage) as defined in `ui-visual-validator`.
- Objective Checklist: Verify every project against WCAG 2.1 contrast standards and pixel-perfect spacing before delivery.

## 7. Cross-Project Consistency (Memory Powered)

### 7.1 Historical Retrieval

- Pre-Flight Search: Before initializing a new page or component, the agent MUST query `agent-memory` for any previously successful patterns, specific color preferences (like the Dark/Onyx priority), or conversion hooks used in other industrial projects.
- Thinking Wider: Use historical data to avoid repeating mistakes and to evolve the design system across multiple separate workspaces.

## 8. Japanese Precision Integration (V5 Upgrade)

Integrating the Japanese Design Standard to achieve 100/100 visual and functional score:

### 8.1 Advanced Typography & "Ma" (Negative Space)

- Breathing Room: Implement a minimum `line-height: 1.75` for all description text and `letter-spacing: 0.02em` for headings.
- Intentional Whitespace: Between complex technical sections, introduce a `120px - 150px` vertical gap to prevent cognitive overload—this is the Japanese "Ma" (间) applied to industrial data.

### 8.2 Visual Signage Logic (Inspired by NAVITIME/Mercari)

- Status Badges: Use high-contrast, bold-background badges for "Status" or "Safety Certs" that mimic Japanese infrastructure signage (High legibility, sharp corners within a rounded container).
- Navigation Clarity: Every section must have a clear "Breadcrumb or Progress Anchor" to tell the user exactly where they are in the "Industrial Journey."

### 8.3 "Soft-Touch" Engineering (Hybrid Aesthetics)

- Refined Rounding: Standardize `border-radius: 16px` for all glass panels and `8px` for buttons. This creates a "precision gadget" feel rather than a "heavy iron" feel.
- Micro-Shadows: Use multi-layered, ultra-soft shadows (`box-shadow: 0 4px 6px rgba(0,0,0,0.1), 0 10px 15px rgba(0,0,0,0.1)`) to lift cards off the Onyx background without looking "dirty."

### 8.4 Contextual Intelligence (UX)

- Service Cross-Linking: On service-specific pages, automatically inject a "Smart Link" to a complementary service (e.g., Fire Protection → Electrical) to mimic the Japanese "Demand Pre-judgment" logic.

---

Verified Status: V5 Upgrade (Japanese Precision) Integrated and Active.


---
---
name: zeta-branding-authority-dna
description: "ZETA Branding Authority DNA"
triggers: ["zeta branding authority dna", "zeta_branding_authority_dna", "zeta branding authority"]
phase: reference
model_hint: gpt-5.3-codex
version: 42.0
_ohdy_wrapper: |-
  # OHDY COMPRESSED NODE (V42.0)
  <dna_node>
  v: 42.0
  n: zeta_branding_authority_dna
  graph:
    req: []
    rel: []
  l: |-
  </dna_node>
---

# ZETA Branding Authority DNA

DNA Version: 5.3.0 (Cinematic Harden // Power AI)
Last Synced: 2026-04-10
Status: MASTERPROTOCOLENFORCED

---

## 0. Tier 1: Master Architecture Protocols [ABSOLUTE]

1.  Web Standards (Vanilla-First): All website projects MUST be built as standalone `.html` (Vanilla HTML/CSS/JS) files. NO VUE for standard websites.
2.  Multi-Page Architecture: High-end websites MUST provide depth through distinct pages: `index.html`, `about.html`, `services.html`, `portfolio.html`, `contact.html`.
3.  Hero Impact: lead with a `100vh` fullscreen element. In V5.3+, this must be a Cinematic Video Background with high-density overlays.
4.  Mobile Navigation: Responsive headers MUST implement a Popup Menu Slider (Off-canvas) for an app-like feel.
57.  Footer Synchronization: Every page within a website ecosystem MUST share a 100% Identical Footer (synchronized content, registration, and addresses).
8.  Self-Healing Deployment (Rule 3.9): `.htaccess` MUST include SPA fallbacks (`RewriteRule . /index.html [L]`) and "access plus 1 month" caching logic for assets.

---

## 1. ZETA V3: Power AI Protocol (Design Tokens)

The V3 protocol shifts from generic colors to a specific, high-contrast HSL-driven palette.

- Primary Color: `#a855f7` (Electric Purple)
- Background: `hsl(260 87% 3%)` (Deep Space Onyx)
- Typography Matrix:
    - Headers: `Orbitron` & `General Sans` (Industrial Precision).
    - Body: `Geist Sans` & `Plus Jakarta Sans` (Digital Modernity).
- Motion Curve: `0.8s cubic-bezier(0.2, 0, 0.2, 1)` (V3 Synergy Curve).

---

## 2. ZETA V5.3: Cinematic Harden Protocol

Standard for top-tier digital experiences requiring "Wow" factor.

### I. Atmospheric Layering
- Video Hero: `hero-bg.mp4` at 40% opacity + saturation boost.
- Galactic Cosmos: Vanilla JS procedural star generation (fallback/accent layer).
- Glow Pulse: Radial gradients with `@keyframes bg-pulse-v5` for breathing depth.

### II. Liquid Glass Material Utility
Sophisticated transparency engine for cards and panels.
```css
.liquid-glass {
  background: rgba(255, 255, 255, 0.01);
  backdrop-filter: blur(4px);
  border: none;
  box-shadow: inset 0 1px 1px rgba(255, 255, 255, 0.1);
}
/* Border-gradient mask logic for technical precision */
```

### III. Interaction Logic (Sticky Sync)
- Showcase: Binding scroll progress to UI state (e.g., sticky phone screen updates).
- Scrambled Text: Lucide-driven icon creation + GSAP-driven character scrambling on hover.

---

## 3. Section-by-Section DNA

| Section | Logic | High-Fidelity Implementation |
| :--- | :--- | :--- |
| Nav (V15) | Hyper-Glass Navbar | Fixed, 56px, backdrop-blur(20px), status pulse. |
| Hero (V3) | Scrollytelling Reveal | `reveal-trigger` for canvas or video-mask deconstruction. |
| Matrix (V5) | Intelligence Ecosystem | 3-column grid, desaturated icons, hover-glow. |
| Timeline | Release Log | Industrial vertical border with pulse indicators. |
| Footer (V5.2) | High-Density Navigation | Industrial Master layout with corporate registration. |

---

## 3. Section-by-Section DNA [EXPANDED]

| Section Type      | DNA Fragment                       | Requirement                                                                 |
| ----------------- | ---------------------------------- | --------------------------------------------------------------------------- |
| Hero (Subpage)| `hero-subpage-wave`                | Atmospheric star layers + meteors + monochromatic mono-tags.                |
| Marquee       | `outline-marquee-v5.3`             | Transparent outlined text + rapid linear animation for "Industrial Speed".   |
| Pricing       | `pricing-grid-tiered`              | 3-tier flex grid + Featured Card highlighted with Primary Glow.             |
| Workflow      | `workflow-lifecycle-grid`          | 6-step lifecycle cards + "Day X" timeline badges.                           |
| Values        | `values-matrix-grid`               | 2-column core values grid + Lucide utility icons.                          |
| Form          | `contact-form-glass`               | High-density glassmorphism card + Large primary submit button.              |
| Portfolio     | `gallery-grid-hover`               | Image overlay with "Visit Circle" transition on hover.                      |

## 4. Interaction Protocols (Logic DNA) [NEW]

- Cinematic Sync (V1.2): `ScrollTrigger` MUST synchronize with smooth scrolling (Lenis) to manage sticky frame image swaps.
- Galactic Cosmos (V1.5): Procedural generation of 50+ stars (`dynamic-star`) with randomized `star-twinkle` and `meteor-fly` CSS animations.
- Form Life-Cycle: Use GSAP to toggle between form entry and success states (`formSuccess.style.display = "flex"`) with `scale` and `opacity` transitions.

## 5. Engineering breakthroughs: Ghost Protocol [NEW]

- Context Optimization (V1.0): Delta-scanning logic that parses modified files in a specific time-window (e.g., 24h) to feed code snippets into the AI context window.
- Automation V16: 13-step automation framework for rapid multi-page deployment.
- Rule 3.9 Hardening: Server-side routing integrity to prevent 404s on refresh for SPA-lite designs.

---

Status: CRYSTALLIZED // CINEMATICHARDENV5.3
Engine: Power AI V3 / Antigravity V16.2





