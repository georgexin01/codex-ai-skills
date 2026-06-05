---
name: figma-automation
description: "Automate Figma tasks via Rube MCP (Composio): files, components, design tokens, comments, exports. Always search tools first for current schemas."
triggers: ["figma automation", "figma-automation", "figma automation rube"]
phase: reference
model_hint: gpt-5.3-codex
version: 42.0
risk: "unknown"
source: "community"
date_added: "2026-02-27"
_inner_frontmatter: |-
  name: figma-automation
  description: "Automate Figma tasks via Rube MCP (Composio): files, components, design tokens, comments, exports. Always search tools first for current schemas."
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

# Figma Automation via Rube MCP

Automate Figma operations through Composio's Figma toolkit via Rube MCP.

## Prerequisites

- Rube MCP must be connected (RUBESEARCHTOOLS available)
- Active Figma connection via `RUBEMANAGECONNECTIONS` with toolkit `figma`
- Always call `RUBESEARCHTOOLS` first to get current tool schemas

## Setup

Get Rube MCP: Add `https://rube.app/mcp` as an MCP server in your client configuration. No API keys needed — just add the endpoint and it works.

1. Verify Rube MCP is available by confirming `RUBESEARCHTOOLS` responds
2. Call `RUBEMANAGECONNECTIONS` with toolkit `figma`
3. If connection is not ACTIVE, follow the returned auth link to complete Figma auth
4. Confirm connection status shows ACTIVE before running any workflows

## Core Workflows

### 1. Get File Data and Components

When to use: User wants to inspect Figma design files or extract component information

Tool sequence:
1. `FIGMADISCOVERFIGMA_RESOURCES` - Extract IDs from Figma URLs [Prerequisite]
2. `FIGMAGETFILE_JSON` - Get file data (simplified by default) [Required]
3. `FIGMAGETFILE_NODES` - Get specific node data [Optional]
4. `FIGMAGETFILE_COMPONENTS` - List published components [Optional]
5. `FIGMAGETFILECOMPONENTSETS` - List component sets [Optional]

Key parameters:
- `file_key`: File key from URL (e.g., 'abc123XYZ' from figma.com/design/abc123XYZ/...)
- `ids`: Comma-separated node IDs (NOT an array)
- `depth`: Tree traversal depth (2 for pages and top-level children)
- `simplify`: True for AI-friendly format (70%+ size reduction)

Pitfalls:
- Only supports Design files; FigJam boards and Slides return 400 errors
- `ids` must be a comma-separated string, not an array
- Node IDs may be dash-formatted (1-541) in URLs but need colon format (1:541) for API
- Broad ids/depth can trigger oversized payloads (413); narrow scope or reduce depth
- Response data may be in `data_preview` instead of `data`

### 2. Export and Render Images

When to use: User wants to export design assets as images

Tool sequence:
1. `FIGMAGETFILE_JSON` - Find node IDs to export [Prerequisite]
2. `FIGMARENDERIMAGESOFFILE_NODES` - Render nodes as images [Required]
3. `FIGMADOWNLOADFIGMA_IMAGES` - Download rendered images [Optional]
4. `FIGMAGETIMAGE_FILLS` - Get image fill URLs [Optional]

Key parameters:
- `file_key`: File key
- `ids`: Comma-separated node IDs to render
- `format`: 'png', 'svg', 'jpg', or 'pdf'
- `scale`: Scale factor (0.01-4.0) for PNG/JPG
- `images`: Array of {nodeid, filename, format} for downloads

Pitfalls:
- Images return as node_id-to-URL map; some IDs may be null (failed renders)
- URLs are temporary (valid ~30 days)
- Images capped at 32 megapixels; larger requests auto-scaled down

### 3. Extract Design Tokens

When to use: User wants to extract design tokens for development

Tool sequence:
1. `FIGMAEXTRACTDESIGN_TOKENS` - Extract colors, typography, spacing [Required]
2. `FIGMADESIGNTOKENSTOTAILWIND` - Convert to Tailwind config [Optional]

Key parameters:
- `file_key`: File key
- `includelocalstyles`: Include local styles (default true)
- `include_variables`: Include Figma variables
- `tokens`: Full tokens object from extraction (for Tailwind conversion)

Pitfalls:
- Tailwind conversion requires the full tokens object including total_tokens and sources
- Do not strip fields from the extraction response before passing to conversion

### 4. Manage Comments and Versions

When to use: User wants to view or add comments, or inspect version history

Tool sequence:
1. `FIGMAGETCOMMENTSINA_FILE` - List all file comments [Optional]
2. `FIGMAADDACOMMENTTOAFILE` - Add a comment [Optional]
3. `FIGMAGETREACTIONSFORA_COMMENT` - Get comment reactions [Optional]
4. `FIGMAGETVERSIONSOFA_FILE` - Get version history [Optional]

Key parameters:
- `file_key`: File key
- `as_md`: Return comments in Markdown format
- `message`: Comment text
- `comment_id`: Comment ID for reactions

Pitfalls:
- Comments can be positioned on specific nodes using client_meta
- Reply comments cannot be nested (only one level of replies)

### 5. Browse Projects and Teams

When to use: User wants to list team projects or files

Tool sequence:
1. `FIGMAGETPROJECTSINA_TEAM` - List team projects [Optional]
2. `FIGMAGETFILESINA_PROJECT` - List project files [Optional]
3. `FIGMAGETTEAM_STYLES` - List team published styles [Optional]

Key parameters:
- `teamid`: Team ID from URL (figma.com/files/team/TEAMID/...)
- `project_id`: Project ID

Pitfalls:
- Team ID cannot be obtained programmatically; extract from Figma URL
- Only published styles/components are returned by team endpoints

## Common Patterns

### URL Parsing

Extract IDs from Figma URLs:
```
1. Call FIGMADISCOVERFIGMARESOURCES with figmaurl
2. Extract filekey, nodeid, team_id from response
3. Convert dash-format node IDs (1-541) to colon format (1:541)
```

### Node Traversal

```
1. Call FIGMAGETFILE_JSON with depth=2 for overview
2. Identify target nodes from the response
3. Call again with specific ids and higher depth for details
```

## Known Pitfalls

File Type Support:
- GETFILEJSON only supports Design files (figma.com/design/ or figma.com/file/)
- FigJam boards (figma.com/board/) and Slides (figma.com/slides/) are NOT supported

Node ID Formats:
- URLs use dash format: `node-id=1-541`
- API uses colon format: `1:541`

## Quick Reference

| Task | Tool Slug | Key Params |
|------|-----------|------------|
| Parse URL | FIGMADISCOVERFIGMARESOURCES | figmaurl |
| Get file JSON | FIGMAGETFILEJSON | filekey, ids, depth |
| Get nodes | FIGMAGETFILENODES | filekey, ids |
| Render images | FIGMARENDERIMAGESOFFILENODES | filekey, ids, format |
| Download images | FIGMADOWNLOADFIGMAIMAGES | filekey, images |
| Get component | FIGMAGETCOMPONENT | filekey, nodeid |
| File components | FIGMAGETFILECOMPONENTS | filekey |
| Component sets | FIGMAGETFILECOMPONENTSETS | file_key |
| Design tokens | FIGMAEXTRACTDESIGNTOKENS | filekey |
| Tokens to Tailwind | FIGMADESIGNTOKENSTOTAILWIND | tokens |
| File comments | FIGMAGETCOMMENTSINAFILE | filekey |
| Add comment | FIGMAADDACOMMENTTOAFILE | file_key, message |
| File versions | FIGMAGETVERSIONSOFAFILE | filekey |
| Team projects | FIGMAGETPROJECTSINATEAM | teamid |
| Project files | FIGMAGETFILESINAPROJECT | projectid |
| Team styles | FIGMAGETTEAMSTYLES | teamid |
| File styles | FIGMAGETFILESTYLES | filekey |
| Image fills | FIGMAGETIMAGEFILLS | filekey |

## When to Use
This skill is applicable to execute the workflow or actions described in the overview.

