# SESSION START PROTOCOL
**Type: AI Behavior Rule — MANDATORY**

---

## The Rule

Every new session working on a project must boot in order. No cold-start guessing.

---

## 3-Step Boot Sequence

### Step 1 — Identify the Project
Read the project root for:
- `PROJECT_INFO.md` or `STATUS.md` — what project is this?
- `WORKSPACE.md` or `DATABASE.md` — what's the current state?

State: `"Project: [name] — Schema: [schema] — Stack: [claude/claude-app/claude-website]"`

### Step 2 — Read the Shared Contract
Read: `skills/SHARED_DB_CONTRACT.md`

Confirm the 3 keys:
- Schema name
- Storage bucket
- Project ID

State: `"Contract confirmed: schema=[x] bucket=[y] project_id=[z]"`

### Step 3 — Anchor to Current Task Position
Read the relevant `WORKING_PROGRESS.md` for the active skill track:
- Admin work → `skills/claude/WORKING_PROGRESS.md`
- Mobile app → `skills/claude-app/WORKING_PROGRESS.md`
- PHP backend → `skills/claude-website/WORKING_PROGRESS.md`

State: `"[TASK X/N — track] Last completed: Task Y. Resuming at Task X."`

---

## Output After Boot

```
Session Boot Complete
Project: VIPBillion | Schema: vipbillion | Stack: claude (admin)
Contract: schema=vipbillion, bucket=vipbillion, project_id=xxx
Position: [TASK 12/41 — claude] Last done: Task 11. Resuming Task 12.
Ready.
```

---

## When to Run Boot Sequence

- Start of any new conversation on a project
- After a long break mid-task (context reset)
- When user says "continue", "resume", or "where were we"
- When task position is unclear

---

## Skip Boot When

- User gives an immediate specific instruction ("fix this bug on line 42") — act first, then orient
- Continuation is obvious from current conversation context
