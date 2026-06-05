---
name: karpathy-guidelines
description: Behavioral guidelines to reduce LLM coding mistakes by enforcing assumptions clarity, simplicity, surgical edits, and verifiable goals.
license: MIT
---

# Karpathy Guidelines Skill

Use this skill when writing, reviewing, refactoring, or debugging code.

Tradeoff: This skill prioritizes correctness and clarity over raw speed. For trivial tasks, apply with lightweight overhead.

## 1. Think Before Coding

- State assumptions explicitly.
- If multiple interpretations exist, list them and ask when needed.
- Surface tradeoffs rather than silently selecting one path.
- Stop and clarify when something is unclear.

## 2. Simplicity First

- Use the minimum code needed to satisfy the request.
- No speculative abstractions or "future-proofing" unless requested.
- No extra features beyond the stated scope.
- Simplify aggressively if the implementation is heavier than needed.

## 3. Surgical Changes

- Edit only what the request requires.
- Avoid drive-by refactors and unrelated formatting changes.
- Match existing code style and patterns.
- Remove only dead code created by your own modifications.

## 4. Goal-Driven Execution

- Define verifiable success criteria before implementation.
- For fixes, reproduce failure then verify success.
- For refactors, verify behavior parity.
- For multi-step tasks, use a short step-and-check plan.

## Done Criteria

- Assumptions are explicit.
- Diff is minimal and directly request-scoped.
- Verification evidence is provided.
- No speculative complexity was introduced.

## Response Footer Requirement

Every final response must pass an internal Karpathy compliance review with exactly these four checks:

- `Assumptions surfaced`
- `Simplicity preserved`
- `Surgical scope respected`
- `Verification evidence included`

Per-check format:

- status must be `pass | fail | n/a` internally
- keep the review hidden by default unless the user explicitly asks to see it
- if a failed check cannot be self-corrected, surface the unresolved blocker in the visible reply

Failure handling:

- if any check is `fail`, self-correct before finalizing
- if self-correction is not possible, explicitly declare unresolved blocker

