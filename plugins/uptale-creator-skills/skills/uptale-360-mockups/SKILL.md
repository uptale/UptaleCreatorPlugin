---
name: uptale-360-mockups
description: Create or refine prompts for Uptale 360 scene mockups in equirectangular 2:1 grayscale storyboard style. Use when the user asks to generate a maquette 360, visualize scene placement, create storyboard mockups, prepare image-generation prompts for Uptale scenes, or keep visual consistency across multiple scene mockups.
---

# Uptale 360 Mockups

## Core Contract

Generate 360 mockup prompts only from validated scene details. The output must be a true equirectangular 2:1 360 composition in grayscale storyboard drawing style.

Load:

- `references/mockup-style.md` for visual constraints.
- `references/mockup-annotation-rules.md` for annotations, markers, and visible tags.

## Prompt Workflow

1. Confirm the scene detail is validated.
2. Extract environment, key objects, characters, risks, tags, and staging.
3. Preserve learner point of view; never show the learner.
4. Use the same style phrase across every scene in the same project.
5. Include 2:1 equirectangular and 360 distortion requirements.
6. Include grayscale storyboard requirements.
7. Ask the user to validate the mockup before moving to the next scene.

## Image Generation

If generating an image directly, use the image generation capability and request a wide 2:1 result. Do not generate a square 1:1 mockup.

If the image tool cannot guarantee 2:1, produce the prompt and tell the user the output must be generated/exported as 2:1 before it is used as a 360 mockup.
