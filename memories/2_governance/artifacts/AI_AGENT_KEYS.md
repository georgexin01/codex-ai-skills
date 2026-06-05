---
name: ai-agent-keys
description: "🔑 AI AGENT KEYS (V1.0) — Multi-Model API Registry for Token Cost Reduction & Performance Routing"
triggers: ["ai agent keys", "claude api", "openai api", "multi model", "token cost", "api keys"]
phase: constitutional
model_hint: codex-gpt-5.3
version: 1.0
status: active
date_added: "2026-04-15"
risk: high
---

# 🔑 AI AGENT KEYS (V1.0) — Multi-Model Router Registry

**Status**: ACTIVE | **Boot Tier**: ROUND 1 | **Security**: LOCAL ONLY — Never commit to git

---

## 1. REGISTERED API KEYS

| Provider | Key Reference | Use Case | Cost Tier |
|---|---|---|---|
| **Anthropic (Claude)** | `CLAUDE_API_KEY` | Complex reasoning, long-context code review, TypeScript architecture | ~$0.003/1K tokens (Sonnet) |
| **OpenAI (GPT-4o)** | `OPENAI_API_KEY` | Code completion, JSON generation, structured output | ~$0.005/1K tokens (4o) |
| **Google Gemini** | `GOOGLE_AISTUDIO_KEY` | Built-in (Antigravity) & AI Studio usage | Flash: cheapest |
| **Stitch (Google)** | `STITCH_API_KEY_1`, `STITCH_API_KEY_2` | High-fidelity design recommendations, premium UI/UX patterns | Multi-key redundancy |

### 1.1 Key Storage (Environment Variables)

Store keys in `.env.local` or Windows System Environment — NEVER in source code:

```env
CLAUDE_API_KEY=<your-anthropic-api-key>
OPENAI_API_KEY=<your-openai-api-key>
GOOGLE_AISTUDIO_KEY=<your-google-aistudio-key>
STITCH_API_KEY_1=<your-stitch-api-key-1>
STITCH_API_KEY_2=<your-stitch-api-key-2>
```

---

## 2. MULTI-MODEL ROUTING STRATEGY (Token Cost Reduction)

### 2.1 Task-to-Model Routing Table

| Task Type | Best Model | Why | Est. Token Saving |
|---|---|---|---|
| Fast scaffold / UI boilerplate | **Gemini Flash** (default) | Cheapest, fastest | Baseline |
| Complex TypeScript architecture | **Claude Sonnet** | Superior reasoning on long code | Save 40% vs GPT-4o |
| JSON/SQL generation | **GPT-4o** | Structured output accuracy | 20% faster than Claude |
| Code review / security audit | **Claude Sonnet** | Best at critical analysis | High quality |
| Image generation / vision | **Gemini** (built-in) | Native integration | Zero API cost |
| Simple Q&A / routing logic | **Gemini Flash** | Fastest latency | Cheapest |

### 2.2 Gemini Token Reduction via Offloading

**How Claude/OpenAI APIs REDUCE Gemini token cost:**

```
BEFORE (Gemini-only):
User asks complex question → Gemini reads all context → High token burn

AFTER (Multi-model routing):
User asks complex question  
  ├── Simple task → Gemini Flash (direct, fast, cheap)
  └── Complex reasoning → Claude API (offload, Gemini orchestrates only)
                          = Gemini only sees summary, not full reasoning chain
                          = 30-50% Gemini token reduction on complex tasks
```

---

## 3. MCP INTEGRATION PLAN

### 3.1 Potential MCP Servers Using These Keys

| MCP Server | API Used | Benefit |
|---|---|---|
| `@anthropic/claude-mcp` | Claude API | Direct Claude tool calls from Antigravity |
| `openai-mcp-server` | OpenAI API | GPT-4o for code completion & structured tasks |
| `claude-code-mcp` | Claude API | Agentic code editing with Claude's extended thinking |

### 3.2 Current MCP Config Status

- **StitchMCP**: Configured but DISABLED (`mcp_config.json` → `"disabled": true`)
- **Claude MCP**: NOT YET CONFIGURED — ready to add
- **OpenAI MCP**: NOT YET CONFIGURED — ready to add

### 3.3 Recommended mcp_config.json Extension

```json
{
  "mcpServers": {
    "StitchMCP": {
      "command": "npx",
      "args": ["-y", "mcp-remote", "https://stitch.googleapis.com/mcp", "--header", "X-Goog-Api-Key: ${GCP_API_KEY}"],
      "disabled": true
    },
    "ClaudeMCP": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-server-claude"],
      "env": {
        "ANTHROPIC_API_KEY": "${CLAUDE_API_KEY}"
      },
      "disabled": false
    }
  }
}
```

---

## 4. SECURITY GUARDRAILS

- **NEVER** hardcode keys in project files (`*.ts`, `*.vue`, `*.env`)
- **NEVER** commit keys to git — add `.env.local` to `.gitignore`
- **ROTATE** keys quarterly or if exposed
- **SCOPE** — Claude key: read-only code tasks only. OpenAI key: structured output only
- Keys in this file are for **REFERENCE ONLY** — actual runtime uses env vars

---

## 5. ANSWER: Does This Help Gemini Performance?

### ✅ YES — Here's How:

1. **Token Deflation**: Route heavy reasoning to Claude → Gemini only orchestrates → Less Gemini tokens burned
2. **Quality Boost**: Claude Sonnet 4.6 Thinking > Gemini Flash for complex TypeScript/Vue architecture reasoning
3. **Speed**: OpenAI GPT-4o is faster for pure JSON/SQL generation — offload batch ops
4. **Cost**: Claude Haiku ~$0.00025/1K tokens — 10× cheaper than Gemini Pro for simple completions

### ⚠️ Limitations:
- Antigravity cannot natively call Claude/OpenAI APIs mid-session (no built-in MCP bridge yet)
- Keys must be wired via MCP server or custom Node.js bridge script
- Requires MCP config update to activate

---
**AI Agent Keys V1.0 — Multi-Model Router Registry (2026-04-15)**
