---
name: stitch-mcp-mastery
description: "Stitch MCP: UI Design and Development Mastery"
triggers: ["stitch mcp mastery", "stitch_mcp_mastery", "stitch design development"]
phase: reference
model_hint: gpt-5.3-codex
version: 42.0
_ohdy_wrapper: |-
  # OHDY COMPRESSED NODE (V42.0)
  <dna_node>
  v: 42.0
  n: stitch_mcp_mastery
  graph:
    req: []
    rel: []
  l: |-
  </dna_node>
---

# Stitch MCP: UI Design and Development Mastery

This guide documents the integration of the Stitch MCP server with the Antigravity agentic workspace. Stitch is used for high-fidelity UI design, component generation, and branding consolidation.

---

## 🛠️ 1. Core Stitch Tools
Stitch exposes its capabilities through a Model Context Protocol (MCP) server. Key tools available to the agent include:

| Tool | Description |
| :--- | :--- |
| `create_project` | Initializes a new UI design project with a prompt. |
| `list_screens` | Retrieves a list of all designed screens for the project. |
| `getprojectsite_file` | Returns the structural architecture and routes. |
| `design-md` | (Skill) Generates the `DESIGN.yaml` System of Record. |
| `enhance-prompt` | (Skill) Transforms a basic idea into a high-fidelity design prompt. |

---

## 🏗️ 2. The Development Workflow
Building a production-ready application with Stitch follows a structured hand-off between Design and Engineering.

### Step 1: Design Phase
The agent uses Stitch to define the site's look and feel.
- Action: Run `create_project` with an aesthetic focus.
- Output: A collection of screens in the Stitch design space.

### Step 2: System of Record
The agent generates the `DESIGN.yaml` file using the `design-md` skill.
- Action: Analyze the project to extract "Project DNA".
- Output: Detailed HEX colors, typography, and "Nano Banana" asset rules.

### Step 3: Build Phase
Antigravity converts the designs into code (React, shadcn-ui, or Vanilla HTML/JS).
- Action: Use `list_screens` to identify components and build them sequentially.
- Baton Pass: Use `.stitch/next-prompt.yaml` to pass progress from one screen to the next.

---

## 🎨 3. Design-to-Code Rules
- Anti-Slop Protocol: Ban generic colors (e.g., pure Black `#000000`). Use the palette defined in `DESIGN.yaml`.
- Aesthetic Fidelity: Ensure transitions, hover effects, and typography match the Stitch design exactly.
- Asset Integration: Use the Nano Banana logic to request/generate assets as the code is written.

---

[!IMPORTANT]
Always verify that the `DESIGN.yaml` exists before building components. It is the only guaranteed way to maintain visual consistency across a multi-component build.

