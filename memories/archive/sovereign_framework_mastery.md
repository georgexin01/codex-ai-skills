---
name: sovereign-framework-mastery
description: "Sovereign Framework (SWF) Architecture & Governance (V15.1 Apex)"
triggers: ["swf", "vben", "sovereign framework", "master architecture"]
phase: constitutional
model_hint: codex-gpt-5.3
version: 15.1
status: authoritative
---

# [💎 MASTERY] | [⚡ MODE: SPECIALIST] | [✅ STATUS: CRYSTAL]

## 🛡️ 1. SOVEREIGN FRAMEWORK (SWF) MASTERY (V15.1)


The architectural standard for all Sovereign Intelligence projects. Governed by the **13 Apex Principles** and optimized for zero-latency execution.

## ⚖️ ARCHITECTURAL GUARDRAILS
1. **Rule #1 (Absolute Isolation)**: All business data MUST reside in a dedicated schema (e.g., `quizLaa`). `public` is for shared governance only.
2. **Principle 5 (Schema Logic)**: All RLS helper functions and RPCs MUST be `SECURITY DEFINER` and resides in the `public` schema.
3. **Principle 12 (Data Sovereignty)**: Original user assets are never stored. Only processed, sanitized markers are used.

## 🧭 THE SOVEREIGN LIFECYCLE (V15.1)

### 1. INFRA & SCHEMA (Genesis)
- **Local-Supabase-Core**: Dockerized instance at `localhost:8000`.
- **Schema Isolation**: Create project schema with snake_case naming.
- **Rule #1 Enforcement**: `ALTER TABLE {schema}.{table} ENABLE ROW LEVEL SECURITY;`.

### 2. DATA & LOGIC (Hydration)
- **Entity Definition**: Mandatory 1:1 mapping between DB and TS Interfaces.
- **Pinia Bridging**: Single-source-of-truth stores with `try/catch` safety.
- **RPC Orchestration**: Use `SECURITY DEFINER` functions in `public` for cross-schema user creation.

### 3. UI & AESTHETIC (Execution)
- **Cinematic Motion**: GSAP/Lenis integration mandatory (60 FPS).
- **Glassmorphism**: Standard blur (24px) + refraction borders.
- **Mobile Purity**: Thumb-zone CTAs and Bottom-Sheet modals only.

## 🧪 APEX VERIFICATION
AI MUST execute a **Sovereign Comparison Table (SCP)** for every project Genesis to verify:
- [ ] Schema Isolation Gap (1/10).
- [ ] RLS Lockdown Fidelity (10/10).
- [ ] Aesthetic Parity Score (1/10).
