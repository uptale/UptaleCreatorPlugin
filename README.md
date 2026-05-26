# UptaleCreatorPlugin

Plugin scaffold for Uptale creators to design immersive storyboards and operate Uptale experiences
through a plugin-local MCP server.

## MCP Runtime

The plugin is wired to load MCP servers from [`.mcp.json`](.mcp.json). The configured server is
`uptale`, and it runs:

```powershell
node ./scripts/run-uptale-mcp.mjs
```

Paste the built MCP runtime from:

```text
C:\Users\LilianCambillau\source\repos\UptalePlatform\McpServer
```

into [`mcp/`](mcp/), so [`mcp/build/index.js`](mcp/build/index.js) exists. If the build is not
self-contained, keep or install the production dependencies in `mcp/node_modules`.

Default environment:

```json
{
  "UPTALE_MCP_ENVIRONMENT": "prod-eu"
}
```

To set the environment once after install, run:

```powershell
.\scripts\set-mcp-environment.ps1 prod-eu
```

Supported values are `dev`, `prod-eu`, `prod-us`, and `local`. The script writes
`mcp/runtime-config.json`, which the MCP launcher reads before falling back to `prod-eu`.

## Static Check

After pasting the MCP build, run:

```powershell
.\scripts\verify-mcp-runtime.ps1
```

The check verifies that the MCP config, runtime package, and `mcp/build/index.js` are present.

## Skill Planning

The proposed skill architecture is documented in
[`docs/skills-roadmap.md`](docs/skills-roadmap.md). It separates the conversation workflow, Uptale
tag/exercise references, MCP application, live review, media planning, final deliverables, and 360
mockup prompting.
