---
name: uptale-live-review
description: Review an existing Uptale experience through read-only MCP discovery against a storyboard, checklist, or production expectations. Use when the user asks to inspect a live Uptale experience, compare scenes/tags/media to validated design, find missing scene content, or propose corrections without applying changes.
---

# Uptale Live Review

## Core Contract

Default to read-only review. Use MCP discovery tools to inspect workspaces, experiences, scenes, and media. Do not apply updates or deletions unless the user explicitly requests a separate correction step and approves the proposed changes.

Load `references/review-checklist.md` before producing a full review.

## Workflow

1. Authenticate with `uptale_login` if needed.
2. Identify workspace and experience.
3. Run `list_scenes`.
4. Run `list_experience_media` when media completeness matters.
5. Compare the live state against the user-provided storyboard or checklist.
6. Report findings by severity:
   - Blocking mismatch.
   - Missing content.
   - Production gap.
   - Improvement suggestion.
7. If changes are needed, hand off to `uptale-mcp-builder` for a dry-run action plan.

## Review Output

Lead with findings, then list open questions and a compact summary. Include scene/tag names and IDs when available.
