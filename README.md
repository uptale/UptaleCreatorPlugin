# UptaleCreatorPlugin

Plugin scaffold for Uptale creators to design immersive storyboards and operate Uptale experiences
through a plugin-local MCP server.

## MCP Runtime

The plugin is wired to load MCP servers from [`.mcp.json`](.mcp.json). The configured server is
`uptale`, and it runs the bundled MCP file directly:

```powershell
node ./mcp/uptale-mcp.mjs
```

Generate the bundled file from:

```text
C:\Users\LilianCambillau\source\repos\UptalePlatform\McpServer
```

by running:

```powershell
pnpm run bundle:plugin
```

That creates `build/uptale-mcp.mjs` in the MCP project. Copy that file into
[`mcp/uptale-mcp.mjs`](mcp/uptale-mcp.mjs) when updating the plugin. It is intended to be
self-contained for the platform used to build it and does not require plugin-local `node_modules` or
`mcp/package.json`.

Default environment:

```json
{
  "UPTALE_MCP_ENVIRONMENT": "prod-eu"
}
```

To change the environment, edit [`.mcp.json`](.mcp.json) and set `UPTALE_MCP_ENVIRONMENT`.

## Static Check

After copying the MCP bundle into the plugin, run:

```powershell
node --check .\mcp\uptale-mcp.mjs
```

That checks the generated file syntax.

## Skill Planning

The proposed skill architecture is documented in
[`docs/skills-roadmap.md`](docs/skills-roadmap.md). It separates the conversation workflow, Uptale
tag/exercise references, MCP application, live review, media planning, final deliverables, and 360
mockup prompting.
