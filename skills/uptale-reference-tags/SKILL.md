---
name: uptale-reference-tags
description: Provide Uptale tag, exercise, option, conditioning, and content-to-activity references while designing immersive scenes. Use when a user or another Uptale skill needs to choose tag types, build tag tables, map pedagogical content to immersive activities, define success criteria, or avoid unsupported MCP tag operations.
---

# Uptale Reference Tags

## Purpose

Use this skill to design valid Uptale scene interactions and tag tables. Keep the user-facing answer practical: tag rows, options, conditions, and success criteria.

Load only the needed reference:

- `references/tag-types.md` for tag capabilities and MCP support.
- `references/exercises.md` for activity patterns.
- `references/conditioning.md` for appearance/disappearance and rule logic.
- `references/content-to-activity.md` for transforming learning content into immersive activities.

## Required Guardrails

- Do not invent Uptale features outside the references.
- For `Text` tags, never propose `Bulle` or `Ouvert`; this is directly displayed text without learner interaction.
- For microphone scenes, include AI prompts, success examples, failure handling, and "nothing heard" handling in the tag table.
- For 2D video scenes, include dialogue plus acting/staging notes in the tag table and media plan.
- Keep criteria of success explicit per scene.
- Distinguish storyboard intent from current MCP support.

## MCP Support Reminder

The current MCP `create_tag` schema supports only:

- `Info`
- `QCM`
- `Canvas`
- `Door`

Other tags may be valid in Uptale design, but should be marked as production/manual work until MCP support is added.
