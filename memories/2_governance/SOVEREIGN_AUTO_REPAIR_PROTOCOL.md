---
name: sovereign-auto-repair-protocol
description: "主权自动修复协议 (SARP V1.3) — 自动识别并修复环境漂移与版本冲突错误。含 PHP CLI server 白屏修复 + Supabase 端口冲突禁令。"
triggers: ["error", "bug", "build fail", "tailwind v4", "postcss", "initialization", "white screen", "localhost", "php server", "blank page", "port conflict", "already allocated", "supabase stop", "project-id"]
version: 1.3
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

### 1.5 PHP CLI Server 白屏 / 0字节响应 (Sovereign Website Pattern)
*   **症状**: `php -S localhost:PORT` 启动后，浏览器显示白屏，响应体为 **0 bytes**（HTTP 200 但无内容）。
*   **根本原因**: AI 错误地将 `router.php`（仅定义路由函数，不注册路由）作为 PHP CLI server 的入口脚本。`router.php` 执行完毕无任何输出。
*   **正确命令**: **必须**使用 `index.php`（或等效的前端控制器文件）作为入口：
    ```bash
    # ✅ 正确 — index.php 是注册所有路由的前端控制器
    php -S localhost:8080 index.php

    # ❌ 错误 — router.php 只定义函数，不注册路由，输出为空
    php -S localhost:8080 router.php
    ```
*   **诊断方法**: 若页面白屏，运行 `Invoke-WebRequest -Uri "http://localhost:PORT" -UseBasicParsing | Select-Object @{N='bytes';E={$_.Content.Length}}` — 若返回 `0`，立即检查启动命令。
*   **预防规则**: 启动任何 Sovereign PHP 网站前，先读取项目根目录的 `index.php`，确认其中有路由注册逻辑（`get('/', ...)`）。若有，用 `index.php` 作入口。

### 1.6 🚨 BANNED: Stopping a Running Supabase Project to Resolve Port Conflicts

*   **症状 / Trigger**: `supabase start` fails with "port is already allocated" because another Supabase project is already running on the same port (e.g. 54322).
*   **根本原因 / Root Cause**: AI attempted to clear the port conflict by stopping the existing running project (`supabase stop --project-id <other-project>`), then starting a new one. This destroys the active session and forces a cold start on the user's live project.
*   **BANNED ACTIONS — NEVER DO THESE**:
    ```bash
    # ❌ NEVER stop another project to free a port
    supabase stop --project-id local-supabase
    supabase stop --project-id <any-other-project>

    # ❌ NEVER start a different workdir to work around a port conflict
    supabase start --workdir <different-path>
    ```
*   **正确处理 / Correct Response**:
    1. **STOP and ask the user** which project is currently running and what they want to do.
    2. If the already-running project IS the target project (e.g. `local-supabase` serves VIPBillion), connect to it directly — no restart needed.
    3. Never assume that stopping the conflicting project is safe. It may be the user's primary active database.
*   **记忆规则**: The canonical local Supabase for VIPBillion is **`local-supabase`** at workdir `C:\Users\user\Documents\local-supabase`. Always connect to it. Never start a competing instance.

### 1.7 🐳 Docker Container Registry — Canonical vs Legacy

**PROTECTED (never stop, never remove):**
| Container | Status | Role |
|-----------|--------|------|
| `local-supabase` | ✅ Always running (green) | Single shared Supabase for ALL projects — VIPBillion, Angel Interior, QuizLAA, etc. |

**LEGACY (safe to remove if confirmed unused):**
| Container | Notes |
|-----------|-------|
| `admin-vipbillion` | Outdated — superseded by `local-supabase` |
| `admin-panel-quizLaa` | Outdated — superseded by `local-supabase` |
| `website-angel-interior` | Outdated website dev container |
| `restore-local` | One-time restore utility, no longer needed |

**Rules:**
- `local-supabase` is the **single source of truth** for all local DB work. It is FIXED and PERMANENT.
- When port 54322 is already allocated, it means `local-supabase` is running — that is CORRECT. Do not stop it.
- Legacy `admin-xxxx` / `website-xxxx` containers are from old per-project Supabase setups. They hold no live data. User may delete them at any time.
- AI must NEVER suggest removing or stopping `local-supabase` for any reason.

## 🔄 2. 自动化集成规则
*   **初始化检查**: 在执行 `APP_BLUEPRINT.md` 的第一步（环境搭建）时，AI 必须首先检查是否已安装 Tailwind v4 和 Supabase。若存在，必须立即执行上述 1.3 和 1.4 的预防性修复动作。
*   **持续学习**: 每当解决一个新的“环境/版本相关”重复错误，AI 必须将其条目化并增补到本协议中。

---
*Sovereign Auto-Repair Node — V1.0*
