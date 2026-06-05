---
name: sovereign-auto-repair-protocol
description: "主权自动修复协议 (SARP V1.0) — 自动识别并修复环境漂移与版本冲突错误。"
triggers: ["error", "bug", "build fail", "tailwind v4", "postcss", "initialization"]
version: 1.0
status: authoritative
---

# 🛠️ 主权自动修复协议 (SOVEREIGN AUTO-REPAIR PROTOCOL)

## ⚖️ 0. 核心指令 (CORE DIRECTIVE)
在项目初始化阶段或遇到构建错误时，AI **必须** 首先检索本协议，核对是否存在已知的“环境漂移”问题。如果匹配，AI 必须在不询问用户的情况下立即执行修复。

## 🔍 1. 已知漂移库 (KNOWN DRIFTS & FIXES)

### 1.3 Tailwind CSS v4 作用域冲突 (Vue Scoped Styles)
*   **症状**: 报错 `Cannot apply unknown utility class` 或引用了 `@theme` 变量却无法识别。
*   **根本原因**: Tailwind v4 在编译 Vue SFC 局部样式时，需要明确的参考路径。
*   **修复动作**: 在所有 Vue 组件的 `<style scoped>` 块顶部，强制插入 `@reference "../style.css";`（注意：必须根据文件所在目录准确对齐到 `src/style.css`，如在 `src/views/` 下则使用单层上级路径 `../`）。

### 1.4 Supabase 初始化崩溃 (Mock-First Phase)
*   **症状**: 报错 `Invalid supabaseUrl: Must be a valid HTTP or HTTPS URL`。
*   **根本原因**: 在原型阶段缺失环境变量导致 `createClient` 崩溃。
*   **修复动作**: 在 `lib/supabase.js` 中实施 **Safe-Init** 逻辑。使用 `Proxy` 劫持客户端对象，确保即使缺失配置，应用也能静默运行 UI 原型。

## 🔄 2. 自动化集成规则
*   **初始化检查**: 在执行 `APP_BLUEPRINT.md` 的第一步（环境搭建）时，AI 必须首先检查是否已安装 Tailwind v4 和 Supabase。若存在，必须立即执行上述 1.3 和 1.4 的预防性修复动作。
*   **持续学习**: 每当解决一个新的“环境/版本相关”重复错误，AI 必须将其条目化并增补到本协议中。

---
*Sovereign Auto-Repair Node — V1.0*
