---
name: dna-logic
description: "主权逻辑 DNA (SOVEREIGN LOGIC DNA) — TS, PINIA & APEX ENGINEERING (V15.1)"
triggers: ["typescript", "ts", "pinia", "store", "state", "entity", "component", "quality", "logic"]
version: 15.1
status: authoritative
---

# 1. 主权逻辑 DNA (SOVEREIGN LOGIC DNA V15.1)

本文件定义了 Antigravity 系统中的工程逻辑标准，强制执行 **规则 #1 (Schema 隔离)** 和 **原则 5 (Schema 逻辑)**。

## 一、 工程防护栏 (ENGINEERING GUARDRAILS)
1. **规则 #1 (绝对隔离)**: 所有数据库访问必须使用 Schema 隔离逻辑。跨项目泄露是 A 级故障。
2. **零本地政策**: 如果库是标准库 (Vue, Supabase, GSAP)，AI 不得阅读本地文档。依靠内部专业知识实现高速开发。
3. **原子 DNA**: 每个实体必须包含：`Interface`, `FormValues`, `Status Enum`, 和 `Options`。

## 二、 编排模式 (ORCHESTRATION PATTERNS)
- **Store 版本控制**: 每个变更操作必须增加 `version: ref(0)` 以触发全局响应式更新。
- **异步安全**: 每个 API 调用必须封装在 `try/catch` 中，并具备主权错误处理。
- **验证**: 所有表单输入必须通过从实体定义生成的 `zod` schema 进行验证。

## 三、 APEX 验证 (APEX VERIFICATION)
AI 在进行任何 Store 或逻辑重构时，必须执行 **主权对比表 (SCP)** 以验证：
- [ ] Schema 隔离间隙 (1/10)。
- [ ] 版本响应式对齐 (1/10)。
- [ ] 异步处理评级 (10/10)。

---
