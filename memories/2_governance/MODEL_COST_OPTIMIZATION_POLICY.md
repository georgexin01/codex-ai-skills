---
name: model-cost-optimization-policy
description: "Model usage policy for minimizing token spend, controlling reasoning depth, and improving cache efficiency across Codex and Claude Code workflows."
triggers: ["model cost", "token cost", "optimize model", "reasoning effort", "cache efficiency", "lean mode", "deep mode", "claude pricing", "codex pricing"]
phase: governance
version: 1.0
status: active
date_updated: "2026-06-02"
---

# Model Cost Optimization Policy

## Mission

Use the strongest model behavior that is necessary, not the strongest behavior that is available.

This policy exists to reduce:
- unnecessary prompt-token spend,
- unnecessary completion-token spend,
- unnecessary high-reasoning usage,
- unnecessary re-hydration of the same `.codex` knowledge,
- unnecessary long answers that do not improve correctness.

It applies to both:
- Codex using `gpt-5.4`
- Claude Code using Sonnet 4.6

## Core Rule

Optimize in this order:
1. reduce context volume,
2. improve route precision,
3. keep outputs short,
4. keep reasoning low by default,
5. escalate only when complexity or risk justifies it.

Do not start by increasing model effort. Start by shrinking the work the model must process.

## Approved Operating Lanes

### 1. Lean Lane

Use for:
- routine coding,
- small fixes,
- file lookup,
- quick explanations,
- short reviews,
- targeted edits,
- project orientation when routing is clear.

Rules:
- use route-first loading,
- read `00_PULSE.md` first and stop at first valid match,
- keep Tier-0 deferred,
- keep reasoning low,
- keep replies concise,
- avoid broad tree scans,
- avoid re-reading `.codex` knowledge in the same chat unless risk changed.

Target effect:
- lowest token cost,
- fastest turnaround,
- highest cache reuse,
- minimal output waste.

### 2. Balanced Lane

Use for:
- medium debugging,
- multi-file changes with known scope,
- implementation planning,
- schema-aware work,
- moderate code review.

Rules:
- keep route-first loading,
- load only the exact deferred files needed,
- keep reasoning low unless ambiguity persists,
- expand output only when needed for clarity,
- verify before escalating into deep mode.

Target effect:
- moderate token cost,
- stable accuracy,
- controlled context growth.

### 3. Deep Lane

Use for:
- unknown-root-cause debugging,
- architecture,
- security-sensitive work,
- governance,
- recovery,
- explicit `deep`, `thorough`, or `review` requests.

Rules:
- escalation must be deliberate,
- read only the exact higher-tier governance files required,
- keep a visible scope boundary,
- use richer reasoning only after lower-cost checks fail,
- compress supporting context aggressively without hiding uncertainty.

Target effect:
- spend more only where it buys correctness,
- avoid using deep mode as a default habit.

## Codex Policy

Current baseline:
- model: `gpt-5.4`
- default reasoning: `low`

Codex defaults:
- routine work -> `gpt-5.4` with `low`
- deep work -> `gpt-5.4` with higher reasoning only when the task clearly qualifies

Codex optimization rules:
- keep the stable instruction prefix at the front so provider-side prompt caching can hit repeatedly,
- avoid changing global instruction wording unnecessarily across similar chats,
- prefer short commentary updates,
- keep final answers compact unless the user asks for detail,
- batch file reads in parallel instead of serial broad scanning,
- preserve the top 20 percent of critical facts verbatim and compress the rest,
- do not reload `00_PULSE.md` or `.codex` knowledge repeatedly inside one chat without cause.

Codex anti-patterns:
- loading `00_CODEX_START_HERE.md`, Tier-0, rollout history, and broad memories for routine work,
- long summaries before doing the actual task,
- repeated restatement of the same workspace rules,
- large final answers when a short answer is enough.

## Claude Code Policy

Claude Sonnet 4.6 optimization rules:
- keep large static instructions stable across requests,
- place reusable instructions before the task-specific part,
- keep frequently reused policy blocks unchanged so cache reads can hit,
- avoid rewriting the full coding constitution every turn,
- ask for concise output by default,
- separate routine coding prompts from deep analysis prompts,
- do not pay deep-thinking cost for lookup, orientation, or narrow edits.

Claude anti-patterns:
- rewriting the full system/process prompt for every request,
- mixing stable instructions with volatile task text in one constantly changing block,
- asking for exhaustive explanations during routine implementation,
- using one giant universal prompt for all task shapes.

## Output Discipline

Output length is a cost control lever.

Default:
- short commentary updates,
- concise final answer,
- longer detail only when risk is high or the user explicitly asks.

Prefer:
- direct outcome,
- verification result,
- remaining uncertainty.

Avoid:
- repeated recaps,
- long background sections,
- verbose bullet inflation,
- restating instructions already established in the same chat.

## Context Discipline

Always prefer:
- route first,
- exact file reads,
- narrow grep,
- one-pass compact memory hydration,
- deferred governance files,
- evidence over speculation.

Avoid:
- full-tree hydration,
- repeated opening of the same long docs,
- bringing rollout summaries into routine work unless prior evidence is directly relevant,
- carrying dead context forward after the route is already resolved.

## Cache Discipline

Provider cache efficiency improves when the repeated prefix stays stable.

Rules:
- keep stable instructions in stable files,
- avoid unnecessary edits to hot boot files,
- keep trigger phrases short and consistent,
- prefer additive targeted policy files over repeatedly expanding the boot file,
- place volatile task details after stable instruction blocks when possible.

Local runtime hygiene:
- keep ignore files aligned,
- prune safe runtime noise when not active,
- do not confuse local filesystem cache paths with provider-side prompt caching.

## Escalation Gate

Before raising reasoning depth or loading deep governance, ask:
1. Is the route already clear?
2. Is the task actually ambiguous?
3. Did a lower-cost check already fail?
4. Will more reasoning likely change the answer?

If the answer is mostly no, stay in the lower-cost lane.

## Benchmark Guidance

Any future model-cost optimization should be measured with:
- prompt tokens,
- completion tokens,
- total tokens,
- cached tokens when available,
- wall-clock time,
- route correctness,
- answer quality,
- estimated cost,
- lane used,
- reasoning setting used.

Keep offline routing benchmarks separate from live model benchmarks.

## Success Standard

The policy is working when:
- routine tasks stay in Lean Lane by default,
- deep reasoning is used deliberately rather than habitually,
- the same chat does not repeatedly reload `.codex` knowledge,
- final answers are shorter without losing correctness,
- live benchmark runs show lower token cost and stable quality.

---
**Model Cost Optimization Policy V1.0 — Governance layer for Codex + Claude Code // 2026-06-02**
