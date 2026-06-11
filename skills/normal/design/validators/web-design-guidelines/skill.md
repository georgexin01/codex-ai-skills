---
name: web-design-guidelines
description: "Review UI code for Web Interface Guidelines compliance. Use when asked to \\\\\\\"review my UI\\\\\\\", \\\\\\\"check accessibility\\\\\\\", \\\\\\\"audit design\\\\\\\", \\\\\\\"review UX\\\\\\\", or \\\\\\\"check my site aga..."
triggers: ["web design guidelines", "web-design-guidelines", "interface guidelines"]
phase: reference
model_hint: gpt-5.3-codex
version: 42.0
risk: "unknown"
source: "community"
date_added: "2026-02-27"
_inner_frontmatter: |-
  name: web-design-guidelines
  description: "Review UI code for Web Interface Guidelines compliance. Use when asked to \\\"review my UI\\\", \\\"check accessibility\\\", \\\"audit design\\\", \\\"review UX\\\", or \\\"check my site aga..."
  risk: unknown
  source: community
  date_added: "2026-02-27"
_ohdy_wrapper: |-
  # OHDY COMPRESSED NODE (V42.0)
  <dna_node>
  v: 42.0
  n: SKILL
  graph:
    req: []
    rel: []
  l: |-
  </dna_node>
---

# Web Interface Guidelines

Review files for compliance with Web Interface Guidelines.

## How It Works

1. Fetch the latest guidelines from the source URL below
2. Read the specified files (or prompt user for files/pattern)
3. Check against all rules in the fetched guidelines
4. Output findings in the terse `file:line` format

## Guidelines Source

Fetch fresh guidelines before each review:

```
https://raw.githubusercontent.com/vercel-labs/web-interface-guidelines/main/command.yaml
```

Use WebFetch to retrieve the latest rules. The fetched content contains all the rules and output format instructions.

## Usage

When a user provides a file or pattern argument:

1. Fetch guidelines from the source URL above
2. Read the specified files
3. Apply all rules from the fetched guidelines
4. Output findings using the format specified in the guidelines

If no files specified, ask the user which files to review.

## When to Use

This skill is applicable to execute the workflow or actions described in the overview.

