---
name: uptale-mcp-builder
description: Convert a validated Uptale storyboard into a dry-run MCP action plan and, after explicit user approval, apply supported scene and tag operations through the Uptale MCP server. Use when the user wants to create scenes, create or update supported tags, inspect workspaces/experiences before applying a storyboard, or understand which storyboard items can be applied through current MCP tools.
---

# Uptale MCP Builder

## Core Contract

Use MCP only after the target workspace/experience and intended changes are clear. Start with a dry-run action plan. Do not mutate an Uptale experience until the user explicitly approves the plan.

Load:

- `references/tool-contracts.md` for current tool inputs and limits.
- `references/storyboard-to-mcp.md` for mapping validated storyboard content to MCP calls.

## Safe Workflow

1. Confirm the user wants to apply changes to Uptale, not only design the storyboard.
2. Run or ask for `uptale_login` if authentication is needed.
3. Discover target workspace and experience if IDs are unknown.
4. Present a dry-run plan:
   - Target workspace and experience.
   - Scenes to create.
   - Tags to create/update/delete.
   - Unsupported storyboard items requiring manual production.
5. Ask for explicit approval.
6. Apply only approved operations.
7. Summarize resulting scene IDs, tag IDs, unsupported items, and follow-up manual work.

## Current Create Support

Use `create_scene` for scene shells. Use `create_tag` only for `Info`, `QCM`, `Canvas`, and `Door`.

Do not attempt to create `Text`, `Audio`, `Image2D`, `Video2D`, `Slides2D`, `Object3D`, `Mic`, `Marker`, `Special`, or `Activity` through current MCP. List them as manual or future-MCP work.

## Destructive Operations

`delete_tag` is destructive. Ask for a second confirmation naming the tag and scene before deleting.
