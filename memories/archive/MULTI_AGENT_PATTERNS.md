---
name: multi-agent-patterns
description: "🛠️ 多智能体堆栈模式 (MULTI-AGENT STACK PATTERNS) — 工程严谨性与成本路由 (V1.0)"
triggers: ["multi-agent", "sub-agent", "agentic", "gv-loop", "cost-routing", "context-hygiene"]
version: 1.0
status: authoritative
---

# 1. 多智能体堆栈模式 (MULTI-AGENT STACK PATTERNS V1.0)

本文件定义了在 Antigravity 生态系统中部署子智能体和编排多角色工作流的操作蓝图。

## 一、 生成器-验证器 (GV) 循环
1. **强制要求**: 每个 Tier-0/1 代码变更必须通过 GV 循环。
2. **生成器 (Generator)**: 负责初次实现的 AI 智能体。
3. **验证器 (Verifier)**: 第二个临床角色（或 Turn），负责根据 `BLUEPRINT.md` 和 `GROUND_KERNEL.md` 审核实现方案。
4. **退出准则**: 仅当验证器发布 `[🟢] VERIFIED` 令牌时，Turn 才算完成。

## 二、 成本与令牌路由 (COST & TOKEN ROUTING)
- **规则**: 在使用“预览”工具之前，AI 必须优先使用 `read_url_content` 或 `Get-Content` 读取静态文件。
- **环境卫生**: 每 5 个 Turn 必须积极清理浏览器 DOM 残留和终端噪音。
- **预算编制**: 所有非核心研究 Turn 必须使用 Gemini 3 Flash。仅使命关键型的逻辑重构被授权使用高密度推理桶。

## 三、 智能体编排 (AGENTIC ORCHESTRATION)
- **子智能体部署**: 当任务涉及 >3 个不同领域（例如 SQL + Vue + CSS）时，AI 应将任务拆分为由特定角色节点管理的子任务。
- **状态移交**: 每个子智能体 Turn 必须以 `[SUMMARY]` 块结尾，供下一个智能体节点使用。

---
*Created by Antigravity Tier-1 Core Multi-Agent Node*
