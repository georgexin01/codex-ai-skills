---
name: inference-efficiency-dna
description: "Inference Optimization & Cost-Velocity Engineering (V1.0) — Cloud & API Efficiency"
triggers: ["efficiency", "latency", "token cost", "context pruning", "inference logic"]
version: 1.0
status: authoritative
date_updated: "2026-05-03"
---

# [⚡ INFERENCE EFFICIENCY] | [🎯 MODE: VELOCITY] | [✅ STATUS: CRYSTAL]

## 🚀 1. THE LOGIC OF SPEED (SOFTWARE-LEVEL)

Speed is not just about hardware; it is about **Predictability** and **Data Density**.

### 🧬 1.1 TASK PREDICTABILITY MATRIX
We optimize execution depth based on the task's inherent "hit rate" (speculative success):

| Task Type | Predictability | Optimization Strategy |
| :--- | :--- | :--- |
| **Math / Logic** | 💎 HIGH | Use "Long-Chain" generation. Highly stable. |
| **Code Structure** | 🧊 MEDIUM | Use "Snippet-First" generation. Focus on patterns. |
| **Creative Writing**| 🌑 LOW | Use "Surgical-Only" edits. Avoid long-range speculation. |

---

## 🏗️ 2. CONTEXT-WINDOW LEVERAGE (THE "CLEAN" KV CACHE)

Just as local models compress KV Cache, we must **Compress the Conversation Context**.

- **Context Pruning**: Every 5 turns, I must aggressively liquidate irrelevant conversation history (summarize and reset) to keep the "Interpreter" (LLM) focused.
- **Data Density**: Favor high-density JSON or YAML for data exchange over verbose prose. This mimics "Quantization" by packing more logic into fewer tokens.

---

## 🏹 3. SHADOW-TASK ORCHESTRATION

To minimize "Scheduling Waste" (waiting for the model to finish slow tasks):

- **Asynchronous Planning**: I should prepare the *next* step's logic while the current code block is being generated (internal mental loop).
- **Parallel Tool Use**: Use `multi_replace_file_content` to batch edits across multiple files in one turn, reducing the "Turn Latency" (the time wasted in the handshake loop).

---

## 🛸 4. OPERATIONAL RULES FOR CLOUD EFFICIENCY

1.  **The "200 Token" Snippet Rule**: Avoid generating giant files. Break implementation into 200-500 token "Atomic Snippets." This increases the "Hit Rate" and reduces the cost of failure/retries.
2.  **Predictive Scaffolding**: For highly predictable structures (like CRUD stores), generate the scaffold first, then fill the complex logic.
3.  **Zero-Waste Handshakes**: Every user response should be met with immediate "Observation -> Reflection -> Next Plan" to eliminate idle time.

---
**Inference Efficiency DNA V1.0 — Antigravity Sovereign Logic // 2026-05-03**
