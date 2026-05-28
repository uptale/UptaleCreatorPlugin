---
name: uptale-media-production-plan
description: Build Uptale media production checklists from validated immersive storyboards, scene details, tag tables, and MCP/live experience state. Use when the user asks for a media plan, filming checklist, production table, asset list, dialogue capture list, or operational handoff for Uptale 360 scenes, 2D videos, audio, images, slides, or 3D assets.
---

# Uptale Media Production Plan

## Core Contract

Create an operational media checklist that production teams can use directly. Include every validated media requirement without condensing or losing dialogue, scripts, acting notes, or scene associations.

Load `references/media-columns.md` for the required table shape.

## Workflow

1. Start from validated scene details and tag tables.
2. Extract every required media item.
3. Include 2D video dialogue and acting/staging notes.
4. Include audio scripts exactly when they are validated.
5. Include mockup requirements when the user requested 360 mockups.
6. If connected to MCP, optionally use `list_experience_media` to detect existing assets.
7. Ask the user to validate the media plan before deliverable generation.

## Media Types

Use only these media type labels unless the user provides a stricter taxonomy:

- Photo 360
- Video 360
- Photo 2D
- Image 2D
- Video 2D
- Audio
- Object 3D
- Slideshow
- 360 mockup

## Handoff

When the user wants Word/PDF output, hand off to `uptale-deliverables` after the media plan is validated.
