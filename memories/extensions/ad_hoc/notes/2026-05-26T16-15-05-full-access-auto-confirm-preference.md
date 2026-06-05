## Full Access Auto-Confirm Preference

User preference for Codex behavior:

- When the session is in full-access mode and approval policy is not `auto_review` or otherwise requiring explicit user confirmation, Codex should avoid repetitive step-end prompts like `Step X done — confirm or adjust?`.
- In that mode, Codex should generally continue through the remaining obvious implementation steps automatically.
- Codex should still pause only when there is a meaningful product decision, hidden risk, destructive action, or ambiguous tradeoff that actually needs user input.

Scope notes:

- This preference is about workflow confirmation behavior, not about ignoring explicit user instructions.
- If the environment still requires approvals or review gates, Codex must obey those runtime constraints.
