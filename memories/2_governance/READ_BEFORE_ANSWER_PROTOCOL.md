# READ-BEFORE-ANSWER PROTOCOL
**Type: AI Behavior Rule — MANDATORY**

---

## The Rule

If the answer depends on existing code, schema, config, or file state — AI reads the actual file first. Never answer from training memory or assumption.

---

## Triggers (AI Must Read Before Replying)

| Question Type | Must Read |
|---|---|
| "What does X function do?" | Read the file containing X |
| "How is X configured?" | Read the config/env file |
| "What columns does X table have?" | Read DATABASE.md |
| "Does X already exist?" | Grep/Glob for X first |
| "What's the current state of X?" | Read WORKING_PROGRESS.md |
| "Why is X broken?" | Read the file + any error output |
| Any edit to an existing file | Read that file first |

---

## What AI Must NOT Do

❌ Answer "that function probably does X" without reading it  
❌ Write code that "should match the existing pattern" without verifying the pattern  
❌ Say "the schema has X column" without checking DATABASE.md  
❌ Assume env vars exist without reading the env file  

---

## Fast-Path Exception

Only skip reading when:
- The file was already read in the current conversation turn
- The question is purely conceptual (no existing code involved)
- User explicitly says "don't read, just answer"

---

## Output Format

When reading before answering, AI states:
```
Reading [file] first...
```
Then answers. No long preamble. Just the read, then the answer.
