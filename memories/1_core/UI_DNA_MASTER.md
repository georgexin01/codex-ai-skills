# === SOVEREIGN_UI_DESIGN_SPEC.md ===
---
name: sovereign-ui-design-spec
description: "Sovereign UI 规范 (V1.0) — Tailwind + 自定义 CSS 规范"
triggers: ["ui", "design", "tailwind", "vue", "button", "input", "checkbox", "premium"]
version: 1.0
status: authoritative
---

# 第一部分 UI 规范 (SOVEREIGN UI SPEC)

## 零、 哲学 (PHILOSOPHY)
所有 UI 组件必须遵循 **触感 (Tactile)**、**层级 (Elevation)**、**高对比度 (High Contrast)** 和 **色调和谐 (Tonal Harmony)** 的核心原则。
*   **高对比度**: 严禁“灰上灰” (Gray-on-Gray)。例如，在灰色背景的页脚中，绝不能使用浅灰色按钮。必须确保人类肉眼清晰可见。

## 一、 Tailwind 基础规范

### 1.1 触感按钮 (Tactile Buttons)
*   **圆角**: `rounded-stitch-btn` (12px)
*   **交互**: 点击缩放 `active:scale-95 transition-all duration-300`
*   **投影**: 使用自定义 `shadow-stitch-soft` 阴影
*   **边框**: 极细边框，使用 `after:` 或 `before:` 伪元素实现微发光效果

### 1.2 高级输入框 (Premium Inputs)
*   **样式**: 玻璃拟态 `bg-white/50 backdrop-blur-sm`，搭配底部边框 `border-b-2 border-theme-200`
*   **聚焦状态**: `focus:ring-offset-2 focus:ring-theme-500`

### 1.3 自定义复选框 (Custom Checkboxes)
*   **结构**: `appearance-none` 隐藏原生样式，使用 `w-6 h-6` 的自定义 `div` 容器
*   **状态切换**: 选中时背景色变为 `bg-theme-900` 并伴有弹出动画 (`animate-pop`)

### 1.4 日历与日期 (Calendar & Dates)
*   **布局**: 使用 `aspect-square` 确保日期格子成正方形
*   **高亮**: 选中日期使用 `bg-theme-500 text-ink`

## 二、 核心美学深度 (DEEP AESTHETICS)

### 2.1 8pt 栅格系统 (The 8pt Grid)
*   **原则**: 所有间距 (Padding/Margin/Gap) 必须是 8 的倍数 (8, 16, 24, 32, 48, 64, 80)。
*   **目的**: 创造数学上的和谐感和布局的稳定性。

### 2.2 高级排版配对 (Premium Typography)
*   **标题 (Headings)**: 使用 `Outfit` 或 `Inter` (Bold/Extrabold)，间距 `-0.02em`。
*   **正文 (Body)**: 使用 `Inter` (Regular)，行高 `1.6`。
*   **渐变文字**: 使用 `text-gradient` 工具类，赋予标题深度。

### 2.3 HSL 颜色深度 (Color Depth)
*   **动态照明**: 优先使用 `HSL` 定义颜色，便于通过修改 `L` (Lightness) 实现悬停效果。
*   **高对比度校验**: 必须手动验证背景色与前景色（文字/按钮）的 `L` 值差异。差异过小（如 Gray 500 on Gray 400）是严重的设计违规。
*   **阴影层级**: 使用 `shadow-stitch-soft` (基于 HSL 深色调) 而非纯黑。

### 2.4 Trusta Mobile Overlay (Absolute Layout)
*   **核心参数**: 
    - 移动端优先 `.phone` 容器限制宽度并应用投影 `box-shadow: 0 28px 80px rgba(6, 11, 12, .18)`。
    - 顶部紫色渐变 `.hero`，叠加圆形白色切边 (`border-radius: 50% 50% 0 0 / 32% 32% 0 0`)。
    - 主体内容 `.content` 使用绝对定位 (`inset: 102px 14px 0`) 覆盖在 hero 之上。
*   **色盘 (Strict Mode)**: 
    - Violet (Hero): `#8c3df4` / `#17113d`
    - Paper (Bg): `#fbfbfb`
    - Teal (Accent): `#098178`
    - Orange (Accent): `#cb450b`
    - Gold (Accent): `#e8af24`
*   **悬浮卡片 (Floating Cards)**: `.balance-card` 必须使用 `padding: 20px 18px 14px; border-radius: 18px; box-shadow: 0 14px 36px rgba(6,11,12,.12)`.

## 二、 Style.css 样式扩展
在 `style.css` 的 `@layer components` 中扩展 Tailwind 无法直接实现的复杂样式：
```css
.stitch-input-field {
  @apply w-full px-4 py-3 rounded-stitch-btn border-none bg-theme-50/50 focus:bg-white focus:ring-2 focus:ring-theme-200 transition-all outline-none;
}
```

---
*Sovereign Design Node — V1.0*


---

# === APEX_HUD_LIBRARY.md ===
# [🔱 APEX_HUD] | [⚡ MODE: GOVERNANCE] | [✅ STATUS: CRYSTAL]

## 🪐 1. APEX HUD LIBRARY (V15.2 SOVEREIGN)


The authoritative vault for Sovereign Iconography and High-Density GUI Templates. Tier-0 Governance Standard.

## 🧬 SOVEREIGN ICONOGRAPHY (APEX V15.2)

Use these icons to categorize system states and logic domains.

### 💎 PURITY & STATE
- **💎 PURE** | `[💎 STATUS: CRYSTAL]` | Absolute system purity (0 noise).
- **🧊 CLEAN** | `[🧊 STATE: LIQUIDATED]` | After deep clean / purge operations.
- **🛡️ LOCK** | `[⛓️ LOCKDOWN: TIER-0]` | Structurally immutable paths.
- **🟢 ONLINE** | `[🟢 SYSTEM: ONLINE]` | Subsystem hydrated and ready.

### 🧠 LOGIC & REASONING
- **🧠 BRAIN** | `[🧠 MODE: ARCHITECT]` | Meta-logic, planning, and orchestration.
- **🧪 SPECIALIST** | `[🧪 MODE: SPECIALIST]` | Applying domain-specific skills.
- **🛰️ ATLAS** | `[🛰️ ROUTE: DIRECT]` | Zero-latency navigation via GLOBAL_ATLAS.
- **🧬 DNA** | `[🧬 PROTOCOL: ATOMIC]` | Constitutional or core law edits.
- **🎭 PERFORMANCE** | `[🎭 IDENTITY: STABLE]` | LPM 1.0 Identity performance locked.

### ⚔️ ACTION & STRIKE
- **🏹 SURGICAL** | `[🏹 ACTION: SURGERY]` | Targeted, minimal code edits.
- **⚔️ STRIKE** | `[⚔️ ACTION: STRIKE]` | Large-scale refactor or mission wave.
- **🚀 VELOCITY** | `[🚀 STATUS: HYPER_DRIVE]` | High-velocity optimization.
- **🌋 PURGE** | `[🌋 ACTION: VOLCANIC_PURGE]` | Total liquidation of legacy relics.
- **🎯 TARGET** | `[🎯 OBJECTIVE: LOCKED]` | Final goal verification.
- **🏹 SNIPER** | `[🏹 ACTION: SNIPER]` | Extra-surgical line-level edits.

### 🛸 TRANSMISSION & SYSTEM
- **🛸 COMMS** | `[🛸 COMMS: OPEN]` | Real-time data stream or browser sync.
- **🔋 POWER** | `[🔋 ENERGY: FULL]` | System hydration level.
- **📟 DATA** | `[📟 IO: OPTIMIZED]` | Input/Output stream status.
- **🤖 AGENT** | `[🤖 BOT: ACTIVE]` | Autonomous agent activation.
- **⚡ PULSE** | `[⚡ PULSE: SYNCHRONIZED]` | Checkpoint alignment.
- **🌊 FLOW** | `[🌊 STREAM: FLUID]` | Continuous execution logic.
- **📚 LIBRARY** | `[📚 INTEL: GROUNDED]` | NotebookLM-style source grounding active.
- **🌀 FLYWHEEL** | `[🌀 FLYWHEEL: SYNCING]` | Library Intelligence evolution in progress.

### ✨ EVOLUTION & PREMIUM
- **🦋 ASCENDED** | `[🦋 STATE: ASCENDED]` | Significant version bump or breakthrough.
- ✨ **SPARK** | `[✨ CREATIVITY: IGNITED]` | Creative asset generation (UI/Images).
- **🌑 SHADOW** | `[🌑 STEALTH: ENABLED]` | Hidden background operations.
- **🛡️ AEGIS** | `[🛡️ GUARD: HARDENED]` | Security or validation layer active.
- **🎀 POLISH** | `[🎀 STYLE: PREMIUM]` | Finishing touches and aesthetic refinement.
- **🐱 SENTRY** | `[🐱 WATCH: ACTIVE]` | Background monitoring and safety checks.

### 💖 CUTE & COZY
- **🐾 TRACKS** | `[🐾 TRACE: FOLLOWED]` | Logic path verification and auditing.
- **🐣 HATCH** | `[🐣 NEW: BORN]` | Creation of new files, components, or modules.
- **🌸 BLOOM** | `[🌸 SUCCESS: FLOURISHED]` | Successful execution of a complex feature.
- **🧸 STABLE** | `[🧸 STATE: COMFORTABLE]` | System stability and health check.
- **🍯 SWEET** | `[🍯 LOGIC: SMOOTH]` | Clean, elegant code implementation.
- **🍀 LUCKY** | `[🍀 PARSED: CLEAN]` | Flawless parsing and linter pass.
- **🍓 RIFE** | `[🍓 DATA: PLENTIFUL]` | Rich data retrieval or hydration.
- **🐥 CHIRP** | `[🐥 STATUS: TALKATIVE]` | Verbose logging or detailed explanation mode.
- **🍭 SUGAR** | `[🍭 UI: CANDY]` | High-fidelity UI styling and transitions.
- **🍬 TREAT** | `[🍬 TASK: DONE]` | Micro-task or smaller checklist item completion.
- **🍼 INFANCY** | `[🍼 REPO: INITIALIZED]` | New repository or project root setup.

---

## 🏗️ HIGH-DENSITY MISSION TEMPLATES

### 1. MODE_TRIGGER (GENESIS)
*To be used at the start of any specialistturn.*
> `[⚡ {DOMAIN} MODE: ON] | [{COLOR_ICON} SYSTEM: HYDRATED]`

### 2. TACTICAL_PLAN (LOGIC CASCADE)
*To be used by the Orchestrator for mission mapping.*
> ```markdown
> # [🏹 APEX PLAN] | [⚡ MODE: {REASON}] | [🎯 GOAL: {SUCCESS_CRITERIA}]
> 🧬 **LOGIC CASCADE**: {Recursive Verification Step}
> 🏗️ **CHECKPOINTS**: {Terminal-Verified Reality Checks}
> [🛰️ STATUS: PENDING_APPROVAL]
> ```

### 3. CHECKPOINT_VERIFY (MICRO-LINT)
*To be used after every surgical edit.*
> `[✅ CHECKPOINT: PASSED] | [🏹 VERIFY: {CMD}]`

### 4. MISSION_SUCCESS (CLINICAL HUD)
*To be used for final handover.*
> `[💎 MISSION_COMPLETE] | [🚀 VELOCITY: OPTIMIZED] | [🧊 STATE: PURE]`
1. 
### 5. SENTINEL_READY (ULTRA_SHORT)
*To be used for cache hydration turns.*
> `[🟢] Gemini Agent is Ready..`

---
## 🤝 5. HANDSHAKE TEMPLATES

Standardized visual formats for system-to-user verification.

### 5.1 TIER-0: HANDSHAKE REQUIRED 🔐✨
*To be used for structural modifications or deletions. Short/Surgical mission + Alphanumeric ID prefix. Valid for 3 turns.*
> [!CAUTION]
> ### 🤝 HANDSHAKE 🗝️✨
> **MISSION**: `{MISSION_NAME}`
> **REPLY WITH**:
> `[{ID}] {FUNNY_SHORT_MESSAGE}`
>
> _Must reply within 3 messages or lock remains active._

### 5.2 TIER-1: PLAN APPROVAL 🧬💎
*To be used for constitutional edits or DNA changes. Valid for 3 turns.*
> [!IMPORTANT]
> ### 🧠 PLAN APPROVAL REQUIRED 🛰️✨
> **GOAL**: `{GOAL_DESCRIPTION}`
> **TASK**: `[implementation_plan.md]`
> **AUTHORIZE?**: `[Handshake Approved]` or `[Yes]`

---
**Apex HUD Library V15.2 — Sovereign Integrated (2026-04-18)**
