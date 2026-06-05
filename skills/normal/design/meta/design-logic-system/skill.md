---
name: design-logic-system
description: "design-logic-system v2.0 (Premium)"
triggers: ["design logic system", "design-logic-system", "skill"]
phase: reference
model_hint: gpt-5.3-codex
version: 42.0
_ohdy_wrapper: |-
  # OHDY COMPRESSED NODE (V42.0)
  <dna_node>
  v: 42.0
  n: SKILL
  graph:
    req: []
    rel: []
  l: |-
  </dna_node>
---

# design-logic-system v2.0 (Premium)

# 设计驱动网页开发核心系统 (高阶版)

## Overview / 概述

This skill integrates Design Token Methodology and Atomic Design into a seamless AI collaborative workflow. It transforms abstract design requirements into machine-readable specs before any code is generated.
本技能将「设计令牌 (Design Tokens)」与「原子设计 (Atomic Design)」整合进 AI 协同流程，在生成代码前将抽象需求转化为机器可读的设计规约。

---

## 🚀 Premium 7-Step Workflow / 高阶7步落地流程

### Phase 1: Context & Intelligence (核心准备)

1. Skill Sync (同步绑定): Bind `Design Management` and `Web Development` skills. Use `system-status` to verify both are active.
   - 指令: "启动设计+开发双引擎，检查技能运行状态。"

2. Information Feeding (深度投喂): Provide 4 categories: Brand Identity, Functional Scope, Technical Stack, and Visual Style.
   - Requirement: Include preferred frameworks (Next.js/HTML) and specific UI references.

### Phase 2: Structural Design (结构化设计)

3. Design Token Generation (设计令牌生成 - CRITICAL):
   - Command the Design Skill to output a JSON/CSS Variable list for: Colors (HSLA), Typography (REM), Spacing (PX-scale), and Elevation (Shadows).
   - Why: This creates the "Single Source of Truth" that the Dev Skill cannot ignore.
   - 指令: "调用设计管理Skill，生成全局设计令牌 (Design Tokens)，输出为 CSS 变量或 JSON 格式。"

4. Atomic Component Blueprint (原子组件蓝图):
   - Define the look of Buttons, Inputs, and Cards individually as Atom components.
   - Why: Atomic design reduces "Hallucinations" during full-page assembly.

### Phase 3: Development & Assembly (开发与组装)

5. Context-Aware Code Generation (上下文敏感代码生成):
   - Provide the Tokens from Step 3 as the mandatory styling base for the Web Dev Skill.
   - Requirement: Request Semantic HTML5 and Modular CSS.

6. Human-in-the-loop QA (人工审核与合规校验):
   - Perform an accessibility audit (contrast, ARIA) and visual consistency check against the Phase 2 specs.
   - 指令: "进行设计合规性检查，确保色值与令牌完全一致，输出无障碍评分分析。"

7. Self-Evolving Delivery (进化式交付):
   - Deliver the Design System Doc + Clean Codebase.
   - Auto-Optimization: AI analyzes if any custom patterns from this project should be saved to the global `knowledge` library.

---

## 🛠 Command Standard / 指令规范

- Explicit Call: Always prefix with `[Call Skill: Name]`.
- Token First: Never request a full page without confirmed Design Tokens.
- Atomic Assembly: Build Atoms -> Molecules -> Organisms.

---

Powered by Anti Gravity Self-Evolving Intelligence. Optimized via Research-Driven Best Practices.

