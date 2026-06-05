---
name: master-app-blueprint
description: "Executable manifest for dual-webapp systems. Continuous evolution template."
version: 10.1
status: master_template
last_updated: "2026-04-28"
---

# 💎 [PROJECT_NAME] - GENESIS BLUEPRINT (V10.1)

> [!WARNING]
> Use this as a structural template ONLY. Clear all project-specific logic before execution.

## ⚙️ 0. 配置元数据 (METADATA)
```yaml
triggers: ["keyword1", "keyword2"]
phase: 0-orchestrator
model_hint: codex-gpt-5.3
requires: [claude-app, sovereign-blueprint-protocol]
unlocks: [generate-store, generate-views]
mock_seed:
  entities: 20
  users: 5
```

## 🎯 1. 核心使命 (CORE MISSION)
*   **愿景**: [输入项目核心愿景，消除运营摩擦。]
*   **语言**: **中文 (Chinese)** 为系统默认且唯一语言。

## 🏗️ 2. 系统架构 (SYSTEM ARCHITECTURE)
### 🧱 2.1 模块拓扑 (Dual-WebApp Standard)
1.  **webApp-Admin**: 独立项目，专注全局资产监控、财务审计与任务分发。
2.  **webApp-Client/Driver**: 独立项目，专注现场任务闭环、离线存证与执行。

### ⚙️ 2.2 技术栈 (TECH STACK)
*   **基础框架**: Vue 3 (Composition API)
*   **样式方案**: Tailwind CSS v4
*   **状态管理**: Pinia (Options API Bakery Pattern)
*   **动画/交互**: GSAP (`stagger: 0.1` 阶梯入场) + Lucide 图标库。

## 🎨 3. UI/UX 工业规格 (VISUAL SPECS & COMPONENTS)
*   **Theme Strategy**: Premium Light (纯白底色 `#FFFFFF` 配合多重品牌色阶梯)。
*   **Sovereign Card**: `bg-white`, `rounded-2xl` (16px), 配合 `.ios-shadow`。
*   **Header/Footer 安全区**: 
    *   顶部: `padding-top: env(safe-area-inset-top)`。
    *   贴底全宽 (Flush Footer): `padding-bottom: env(safe-area-inset-bottom)`。

## ⚡ 4. 交互心理学与防呆 (INTERACTION & ROBUSTNESS)
*   **空状态公式**: 强制包含插图、大标题、副标题与【刷新】按钮。
*   **Aha 时刻**: 新用户 30 秒内感知高价值（微动效、人性化 Onboarding）。
*   **降级重定向**: 数据或权限缺失时，静默 `router.replace` 至安全父级。

## 🛡️ 5. AI 执行铁律与静态门禁 (AI REASONING & CI GATES)
1.  **设计冻结**: 严禁擅自抽取改动并污染全局色彩。
2.  **绝对隔离**: `src/views/` 禁止直调 API 客户端（强制走 Store actions）。
3.  **零原生拦截**: 视图严禁使用原生 `<img >` 与 `alert()`。

---
## 🔗 相关参考 (Related Links)
*   **全局总纲**: [MASTER_BLUEPRINT.md](MASTER_BLUEPRINT.md)
*   **自动化门禁**: [SOVEREIGN_VERIFY_SUITE.md](../../2_governance/SOVEREIGN_VERIFY_SUITE.md)
*   **交互规范**: [SOVEREIGN_INTERACTION_PATTERNS.md](../../1_core/SOVEREIGN_INTERACTION_PATTERNS.md)

---
*Created by Antigravity Tier-0 Governance Node*
