# Storyboard To MCP Mapping

## Planning Rules

Create a dry-run plan before writing:

| Storyboard item | MCP action | Notes |
| --- | --- | --- |
| Validated scene shell | `create_scene` | Choose `Pic360`, `Video360`, `Void`, or `SeeThrough` from scene environment |
| Info/explanation panel | `create_tag` with `Info` | Use title and text from validated scene |
| Quiz | `create_tag` with `QCM` | Include answer titles, correctness, feedback sound if known |
| Navigation | `create_tag` with `Door` | Use scene destination when known |
| Canvas layout | `create_tag` with `Canvas` | Use caption/fields supported by MCP |
| Text instruction | Manual/future MCP | Current create schema does not support `Text` |
| Marker/risk target | Manual/future MCP | Current create schema does not support `Marker` |
| Microphone roleplay | Manual/future MCP | Preserve prompt and rules in unsupported section |
| 2D video/avatar | Manual/future MCP | Preserve dialogue and staging in media plan |
| Audio feedback | Manual/future MCP | Preserve script and file name in media plan |
| Timer/score | Manual/future MCP | Current create schema does not support `Special` |

## Dry-Run Plan Format

Use:

1. Target: workspace, experience, language if relevant.
2. Scene actions: one row per scene to create.
3. Supported tag actions: one row per supported tag.
4. Unsupported/manual production items: one row per item.
5. Questions or risks.

Ask: "Do you approve applying only the supported MCP actions above?"

## After Applying

Return:

- Created scene IDs.
- Created/updated/deleted tag IDs.
- Unsupported items still to produce manually.
- Any failed operation and suggested retry.
