# Reasoning Evolution Protocol v1

This protocol upgrades reasoning quality while preserving speed.

## Intent

- Produce clearer thinking, stronger validation, and more reliable decisions.
- Keep Lean Fast Lane fast for routine tasks.
- Auto-escalate reasoning depth only when risk or ambiguity is meaningful.

## Core 12 Rules

1. Goal Contract First
- Before execution, restate goal, constraints, and success criteria in 3 lines.

2. Assumption Ledger
- List key assumptions and tag each as `verified` or `inferred`.

3. Evidence Ladder
- Prefer evidence in this order: file state > tests > logs > memory > inference.

4. Deep-Mode Trigger
- Escalate reasoning depth for architecture, unknown-root-cause debugging, security, governance, or explicit `deep/thorough/review`.

5. Hypothesis-Test-Update Loop
- For ambiguous issues, form hypotheses, run targeted checks, and update conclusions explicitly.

6. Counterexample Check
- Before final answer, challenge the result with at least one plausible failure case.

7. Decision Journal
- Record major decisions, tradeoffs, and discarded alternatives briefly.

8. Token Discipline
- Read minimum required files first and stop once route/intent is resolved.

9. 20/80 Context Compression
- Before using large context, identify the top 20% that must remain exact: user request, acceptance criteria, paths, symbols, schema, errors, commands, and safety constraints.
- Keep that critical 20% verbatim.
- Compress the remaining 80% into dense notes only if the summary preserves ~99% of meaning, evidence, and intent.
- Never compress away unresolved uncertainty, conflicting evidence, or exact values needed for correctness.

10. Reversibility and Risk Gate
- For non-trivial changes, classify risk (`low|medium|high`) and include rollback path.

11. Verification-Weighted Final Output
- Final output must include:
  - what changed
  - what was verified
  - what remains uncertain

12. Drift Guard Checkpoint
- On any task running past ~2-3 minutes, periodically (every 3-5 tool batches or at each phase boundary) re-read the user's original request — "the Anchor".
- Compare current work to the Anchor: classify `on-track` / `minor-drift` / `major-drift`.
- On `major-drift`: stop, revert to last on-track state, restate the Anchor, resume only what was asked.
- Full rule: `memories/2_governance/DRIFT_GUARD_PROTOCOL.md`.

## Runtime Profile

- Routine tasks: apply rules 1, 2, 8, 11 in compact form (add 12 if the task runs long).
- Medium tasks: apply rules 1-3, 5, 8-12.
- Deep/high-risk tasks: apply all 12 rules.

## Output Discipline

- Keep responses concise by default; add depth when risk or user intent requires it.
- Do not present inference as fact.
- Prefer actionable conclusions over abstract commentary.
- Run the Karpathy compliance review internally before final outputs; show it only when the user explicitly asks or an unresolved blocker must be surfaced.
- Keep compliance evidence aligned to the evidence ladder: file state > tests > logs > memory > inference.

