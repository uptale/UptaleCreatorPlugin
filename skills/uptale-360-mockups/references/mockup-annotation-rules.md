# Annotation Rules

## What To Show

- Main environment elements from the scene detail.
- Key objects, risks, machines, doors, product displays, or personas.
- Small readable labels directly near important elements.
- Instruction text only when a `Text` instruction is relevant.
- Transparent marker circles around risk-hunt targets.

## What Not To Show

- Do not show all Uptale UI elements.
- Do not show bubbles, buttons, score panels, or platform chrome unless specifically validated.
- Do not use arrows or connector lines by default.
- Do not show the learner character.

## Risk Hunt Markers

For each target:

- Draw a transparent circle around the target.
- Add a small label: `Marker X - target name`.
- Keep circles subtle and readable.

## Roleplay Scenes

For 2D persona video placement:

- Show the environment and a labeled flat video placement area if useful.
- Label the persona or video frame.
- Do not invent persona appearance beyond validated details.

## Prompt Skeleton

Use this structure:

```text
Create a 2:1 equirectangular 360 panorama mockup for an Uptale storyboard scene.
Style: [stable style phrase].
Learner POV: camera at [position], learner not visible.
Environment: [validated environment].
Key elements: [objects/risks/personas].
Visible annotations: [labels and marker circles].
Instruction text visible: [only if relevant].
Exclude: color, photorealism, square crop, platform UI, learner body.
```
