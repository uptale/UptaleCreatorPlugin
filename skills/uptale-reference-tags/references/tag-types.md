# Tag Types

## Current MCP Support

| Tag type | Storyboard use | Current MCP create support |
| --- | --- | --- |
| Text | Direct instruction or label displayed in scene | No |
| Audio | Voice-over, feedback, ambiance | No |
| Image 2D | Logo, illustration, pictogram | No |
| Video 2D | Avatar, persona, product zoom, procedure clip | No |
| Info | Rich text panel, explanation, feedback | Yes |
| Slides 2D | Image sequence or slide-like procedure | No |
| Door | Navigation to scene, URL, experience, exit, or session detail | Yes |
| Marker | Clickable area, risk hunt target | No |
| Object 3D | 3D model, manipulation, target interaction | No |
| Microphone | Voice recognition, roleplay, AI conversation | No |
| Special | Timer or score display | No |
| QCM | Quiz or decision with answers | Yes |
| Canvas | Canvas panel/layout content | Yes |

## Common Options

- Bubble: visible clickable entry point.
- Open: auto-open on appearance.
- Invisible: hidden tag, often for hotspot behavior.
- Star gain: award score when completed.
- Markdown: text formatting where supported.
- Border, transparency, size, color, font, alignment.
- Audio overlap: allow multiple sounds at the same time.
- Ambient or spatialized audio.
- Video controls, loop, transparency, border.
- Multiple attempts or single attempt for QCM.

## Special Rule For Text Tags

For `Text`, never propose `Bulle` or `Ouvert`. Treat it as a text panel directly visible in the scene.

## Microphone Notes

For microphone scenes, define:

- Mode: listen and recognize, record and replay, or AI conversation.
- Recognition language.
- Minimum and maximum duration.
- Smart stop and pause duration.
- AI prompt or keyword rules.
- Success action.
- Failure action.
- "Nothing heard" action.

## QCM Notes

For QCM:

- Include question title/text.
- Include every answer, correctness, feedback audio if needed, and destination if applicable.
- Use multiple attempts for training; use single attempt for strict assessment.
- For multi-outcome decisions, consider doors or scene branches.
