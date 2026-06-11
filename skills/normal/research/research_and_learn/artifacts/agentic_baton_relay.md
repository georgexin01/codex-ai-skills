---
name: agentic-baton-relay
description: "Agentic Baton Relay: State Preservation Methodology"
triggers: ["agentic baton relay", "agentic_baton_relay"]
phase: reference
model_hint: gpt-5.3-codex
version: 42.0
_ohdy_wrapper: |-
  # OHDY COMPRESSED NODE (V42.0)
  <dna_node>
  v: 42.0
  n: agentic_baton_relay
  graph:
    req: []
    rel: []
  l: |-
  </dna_node>
---

# Agentic Baton Relay: State Preservation Methodology

This guide documents the Baton Relay protocol, a system designed to maintain state and context across long-running, autonomous agent loops (e.g., building complex multi-page applications).

## 🧩 1. The Baton Concept
In agentic workflows, "Baton" refers to a compact, structured relay file that passes instructions and state from one agent execution to the next. This prevents context drift and ensures the agent always knows its current mission status.

### File: `.stitch/next-prompt.yaml`
This is the standard relay file. It uses YAML front matter followed by the specific next-step goals.

---

## 📋 2. Relay Structure (YAML Example)
A typical baton file contains the current page context, the global mission target, and the immediate next task.

```markdown
---
page: dashboard
status: designing
nextaction: listscreens
---
# Mission: Build SaaS Dashboard
The design system (DESIGN.yaml) is already established. 
Now, list all screens and prepare the 'settings' view.
```

---

## 🔄 3. The Baton Loop Logic
The workflow follows a 5-step recursive loop:

1. PLAN: Antigravity breaks down the user's high-level request into a structured task list.
2. DESIGN: Stitch creates the visual "DNA" (`DESIGN.yaml`) and initial UI screens.
3. BATON PASS: The agent writes the current state and next goal to `.stitch/next-prompt.yaml`.
4. BUILD: Antigravity reads the baton and generates production-ready React/shadcn-ui components.
5. ITERATE: The loop repeats until all screens, components, and tests are successfully verified.

---

## ⚡ 4. Implementation Rules
- Rule of One: Only one baton file exists at a time to ensure a linear, traceable execution path.
- State Integrity: Every relay MUST include the current page/component path so the agent can resume instantly.
- Mission Lock: The primary mission (e.g., "Build an E-commerce site") must be repeated in the baton to keep the agent grounded.

---

[!TIP]
Learning Source: [Antigravity + Stitch MCP: AI Agents That Build Complete Websites](https://www.youtube.com/watch?v=7wa4Ey_tCCE)
Protocol: Research and Learn V2.0 (Agentic Expansion)

