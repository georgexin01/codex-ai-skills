---
name: hybrid-format-protocol
description: "Canonical rules for writing AI knowledge and skills in the 5-language hybrid system (YAML, MD, JSON, TOON, XML) optimized for route-first token efficiency."
triggers: ["hybrid format", "format rules", "how to write skill", "how to write knowledge", "new skill", "new knowledge", "format protocol", "fast format routing"]
phase: constitutional
requires: [ALPHA_DIRECTIVE]
v_score: 1.0
k_decay: 0
holo: "Canonical 5-language format system for AI knowledge/skills. Enforces YAML frontmatter + MD body rules for token efficiency."
model_hint: codex-gpt-5.3
version: 1.1
status: authoritative
date_created: "2026-04-13"
applies_to: "all new and updated knowledge/skills files across all modes (claude, faucet, normal, _shared)"
---

# HYBRID FORMAT PROTOCOL (V1.0)

> The canonical 5-language format system for all AI knowledge and skills files.
> Any new or updated knowledge/skill MUST follow the rules below.

## 1. WHY THIS EXISTS

Fast route-first agents benefit from structured output + literal keyword matching. Writing skills in the wrong format costs tokens (up to 45% per call), breaks routing accuracy, and makes maintenance fragile. This protocol fixes that with one rule: **match the format to the content type.**

Goals:
- **Token efficiency** — avoid wrapper overhead (e.g. OHDY `l: |-` YAML blocks wasted ~13% tokens)
- **Router accuracy** — frontmatter `triggers[]` enables literal keyword routing without reading the body
- **Parse reliability** — stop wrapping markdown in YAML strings where escape rules break on colons/quotes
- **Structured output compatibility** — Gemini 3 Flash's strongest mode needs explicit `output_format` contracts
- **Cross-file portability** — skills should be copy-pasteable without custom loaders

## 2. THE 5 LANGUAGES AND WHEN TO USE EACH

### 2.1 Decision Table (authoritative)

| Content type | Format | Why | Example files |
|---|---|---|---|
| **Instructions, playbooks, guides, protocols, skills** | **Hybrid Markdown** (YAML frontmatter + MD body) | Prose + tables + code — MD native; frontmatter enables cheap routing | `skill.md`, `handbook.md`, `*_protocol.md` |
| **Config, registry, index, map, router, rules** | **Pure YAML** | Key-value state, not prose; YAML parses faster for structured reads | `mode_config.yaml`, `category_index.yaml`, `hub.yaml` |
| **Machine state, timestamps, metadata, API payloads, versioned checkpoints** | **JSON** | Universal, fast, no whitespace ambiguity; best for programmatic read/write | `timestamps.json`, `metadata.json`, `shortform_registry.json` |
| **Append-only ledgers, compact session logs, token-efficient history records** | **TOON** (`.toon`) | Token-Oriented Object Notation — 3-5× more compact than JSON for repeated records | `faucet_session_ledger.toon`, `faucet_history_audit.toon` |
| **Schema-validated documents, prompt templates with strict tags, structured output contracts** | **XML** | Only when you need explicit open/close tags for tool-use or multi-section structured output | `<tool_use>`, `<thinking>`, `<output_format>` blocks |

### 2.2 Quick Decision Tree

```
Is the file mostly prose + code + tables?
├── YES → Hybrid Markdown
└── NO → Is it structured data (keys + values)?
         ├── YES → Is it state/metadata/machine-updated?
         │        ├── YES → JSON (or TOON if repeated records)
         │        └── NO → YAML (config, registry, rules)
         └── NO → Does it need XML tags for tool use / structured output?
                  ├── YES → XML
                  └── NO → Reconsider — probably Hybrid MD
```

### 2.3 Anti-Patterns (FORBIDDEN)

| Anti-pattern | Why it's wrong | Correct alternative |
|---|---|---|
| Wrapping markdown in `l: \|-` YAML string (OHDY style) | 13% token overhead, fragile escape rules, parser-hostile | Hybrid MD with YAML frontmatter |
| Using XML tags inside YAML (e.g. `<dna_node>` in `.yaml`) | Neither format, breaks both parsers | Hybrid MD if prose, pure YAML if data |
| Instructions written as pure YAML bullet lists | Flash routes worse on YAML prose than MD prose | Hybrid MD |
| Config values written as Markdown tables | Programmatic reads need structured YAML/JSON | YAML or JSON |
| Timestamps/state as YAML | JSON is faster, safer, canonical | JSON |
| Mixing formats inside a single file without frontmatter boundary | Ambiguous parse | Hybrid MD frontmatter + body |

## 3. HYBRID MARKDOWN FRONTMATTER SCHEMA (Canonical)

Every `.md` skill or knowledge file MUST have this frontmatter block at the top.

### 3.1 Required fields

| Field | Type | Purpose |
|---|---|---|
| `name` | string | Unique ID, matches folder or filename (no spaces) |
| `description` | string | One-line summary (max 500 chars) — used by router for fallback semantic match |
| `triggers` | string[] | 2-5 literal keywords the router matches against user input |
| `phase` | enum | `constitutional` \| `0-orchestrator` \| `1-analysis` \| `2-scaffold` \| `3-testing` \| `reference` |
| `model_hint` | enum | `codex-gpt-5.3` (fast scaffold) \| `claude-code` (heavy reasoning) |
| `version` | string | Skill version for cache-busting |

### 3.2 Optional fields

| Field | Type | Purpose |
|---|---|---|
| `requires` | string[] | Skill IDs that must run first |
| `unlocks` | string[] | Skill IDs this one enables |
| `inputs` | string[] | Required input parameter names |
| `output_format` | string | Structured output contract (e.g. `json_files`, `sql_migration`, `structured_confirmation`) |
| `risk` | enum | `safe` \| `unknown` \| `high` |
| `source` | string | Origin (`community`, `internal`, URL) |
| `date_added` | ISO date | `YYYY-MM-DD` |
| `status` | enum | `draft` \| `active` \| `deprecated` \| `authoritative` |

### 3.3 Template (copy this for new skills)

```markdown
---
name: my-new-skill
description: "One-line description — what this skill does and when to use it."
triggers: ["keyword one", "keyword two", "keyword three"]
phase: 2-scaffold
requires: []
unlocks: []
inputs: [entity_name, field_list]
output_format: typescript_files
model_hint: codex-gpt-5.3
version: 1.0
---

# My New Skill

## When to Use
One sentence. Flash routes on this — keep it literal, not poetic.

## Steps
1. Imperative verb first. Short.
2. One action per step.
3. End each step with expected signal.

## Output
Return: { "status": "...", "files": [...] }

## Guardrails
- DO NOT do X.
- STOP if step 2 fails.
```

## 4. FORMAT-SPECIFIC RULES

### 4.1 Hybrid Markdown (.md)

- **MUST** start with `---` frontmatter block
- **MUST** include all required fields from §3.1
- Body uses `##` headings for Flash to chunk on
- Keep body under 400 tokens per section for Flash latency
- Use imperative voice in step lists ("Do X", not "You should do X")
- Use CAPS for MUST/DO NOT/STOP guardrails — Flash respects these strongly
- Tables for structured comparison (Flash reads tables well)
- Code blocks for exact syntax (no paraphrasing)

#### 4.1.1 Principle 11: Header Loading (Apex Standard)
To achieve zero-redundancy reading and max token efficiency:
- **Default Behavior**: AI will only load the YAML frontmatter and `## When to Use` section.
- **Full Loading**: The complete file body is ONLY loaded if the frontmatter contains `execution: CRITICAL` or if a specific step is required for the active task.

### 4.2 Pure YAML (.yaml)

Use when content is genuinely structured data:

```yaml
# mode_config.yaml — valid use of pure YAML
mode: claude
triggers: [ai claude, architect, vben]
folder_lock: [skills/claude, memories/claude, _shared]
blocked: [skills/faucet, memories/faucet]
phase_gates:
  1: data_layer
  2: mock_layer
  3: ui_layer
```

Rules:
- Top-level keys are machine-readable (no prose dumps)
- No `l: |-` multiline prose blocks — those belong in hybrid MD
- Use lists, maps, scalars only
- Comment lines with `#` for human context
- NEVER mix XML tags into YAML

### 4.3 JSON (.json)

Use for state, timestamps, metadata, programmatic payloads:

```json
{
  "lastUpdated": "2026-04-13T12:00:00Z",
  "version": "42.0",
  "skills": {
    "brainstorming": { "lastRun": "2026-04-12", "runCount": 17 }
  }
}
```

Rules:
- ISO 8601 for dates
- camelCase for keys
- No comments (use `_meta` fields if needed)
- Pretty-print (2-space indent) for human-readable files; minify for transport

### 4.4 TOON (.toon)

Use for append-only ledgers where records repeat the same shape — TOON compresses repeated keys 3-5× better than JSON.

```toon
# faucet_session_ledger.toon
@schema: [ts, platform, reward, status]
2026-04-13T09:00:00Z | viefaucet | 0.012 | verified
2026-04-13T09:01:00Z | 99faucet  | 0.008 | verified
2026-04-13T09:02:00Z | viefaucet | 0.000 | failed
```

Rules:
- First line declares schema: `@schema: [field1, field2, ...]`
- Each record is one line, `|` separator
- Append-only (never rewrite old lines)
- Human-readable without parsing
- Use when file will have 100+ repeated records

### 4.5 XML

Use ONLY for structured output tags in tool-use prompts or contract-enforced sections:

```xml
<tool_use>
  <name>analyze_schema</name>
  <input>
    <entity>User</entity>
    <fields>id, name, email</fields>
  </input>
</tool_use>
```

Rules:
- Never use XML for general knowledge storage
- Only when Gemini 3 Flash's tool-use or structured-output mode requires it
- Keep tag depth ≤ 3
- Self-close empty tags: `<break/>`

## 5. TOKEN EFFICIENCY PRINCIPLES (Gemini 3 Flash)

1. **Thin frontmatter** — only fields the router needs. Don't dump content into YAML keys.
2. **Body chunked by `##` headings** — Flash skims headings to decide what section to read.
3. **Literal triggers** — 2-5 exact phrases the user might say. Not semantic paraphrases.
4. **Model hint routing** — send heavy reasoning to `claude-code`, light scaffold to `codex-gpt-5.3`.
5. **Output contracts** — declare `output_format` so Flash's structured-output mode locks onto it.
6. **Cache-friendly** — keep total corpus under 1M tokens per mode so it stays in context cache.
7. **No duplication** — don't repeat content across frontmatter + body. Frontmatter for routing, body for execution.

## 6. PROFESSIONAL RESPONSE LAYOUT (CAR PROTOCOL)

To maintain a professional, "finished" GUI in every chat response while obeying the 11 Apex Principles, all major logic or system replies MUST follow the **Cinematic Apex Response (CAR)** standard.

### 6.1 The Apex Status Bar
Every response MUST start with a bold status bar identifying the core operational mode and verification result.
> **`[APEX: PRINCIPLE] | [MODE: ACTIVE_MODE] | [✅ STATUS: RESULT]`**

### 6.2 The Goal-Verification Table
For any multi-step execution, use a compact Markdown table to prove **Principle 5 (Goal-Driven Execution)**.
| Step | Goal | Strategy | Status |
| :--- | :--- | :--- | :--- |
| **01** | Sub-goal | Tool/Logic used | `[VERIFIED]` |

## 7. QUANTUM BENTO-APEX (QBA) HIGH-FIDELITY STANDARD

For "Mega-Design" tasks or when the user demands top-tier visual fidelity, the AI responses MUST upgrade to the **Quantum Bento-Apex (QBA)** protocol.

### 7.1 The "Neural HUD" (Header Block)
Every QBA response MUST start with a single, surgical status line.
> **`[🔪 APEX] | [⚡ MODE: ACTIVE_MODE] | [✅ STATUS: RESULT]`**

### 7.2 "Neural Loop" Visualization (Mermaid)
For any task with **3 or more logic steps**, the AI MUST generate a Mermaid diagram at the top to visualize the thinking path.

## 8. SOVEREIGN COMPARISON PROTOCOL (SCP)

Whenever a "Comparison", "Audit", or "Before/After" task is triggered, the AI MUST generate a **Performance Comparison Table**. This ensures 10/10 precision in evaluating code or system evolution.

### 8.1 SCP Triggers
- `comparison`, `compare`, `before & after`, or any manual "compare" request.

### 8.2 The Canonical SCP Table Columns
The table MUST include the following columns (use N/A if a metric is not applicable):
- **Metric**: The category of comparison.
- **Baseline (Pre)**: The state before changes.
- **Optimization (Post)**: The state after changes.
- **Rating 1/10**: The quality or performance score (1-10).

### 8.3 Specific Metrics to Audit
The first 5 metrics are **MANDATORY** for every Comparison Table:
- **Token Spend** [MANDATORY]: Total token count.
- **Token Cost** [MANDATORY]: USD or credit cost.
- **Speed Time** [MANDATORY]: Generation or execution latency (seconds/ms).
- **Speed % Increase** [MANDATORY]: Relative performance gain.
- **Rating 1/10** [MANDATORY]: Subjective or system-graded fidelity score.
- **Points (+/- 0.000)**: (Optional) Numerical precision points.
- **Pros & Cons**: (Optional) Bulleted qualitative feedback.
