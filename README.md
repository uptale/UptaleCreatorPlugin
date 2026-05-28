# UptaleCreatorPlugin

Plugin scaffold for Uptale creators to design immersive storyboards and operate Uptale experiences
through a plugin-local MCP server.

## Git Marketplace

This repository includes a Codex marketplace file at
[`.agents/plugins/marketplace.json`](.agents/plugins/marketplace.json). Add this repository as a Git
marketplace in Codex to install the `uptale-creator` plugin.

The marketplace entry points to [`./plugins/uptale-creator`](plugins/uptale-creator), which contains
the plugin manifest, skills, and bundled MCP runtime.

## MCP Runtime

The plugin is wired to load MCP servers from
[`plugins/uptale-creator/.mcp.json`](plugins/uptale-creator/.mcp.json). The configured server is
`uptale`, and it runs the bundled MCP file directly:

```powershell
node ./mcp/uptale-mcp.mjs
```

The MCP config also sets `cwd` to the plugin root. Keep that in place: Codex may start bundled MCP
servers from the current workspace or app process directory, and the relative `./mcp/uptale-mcp.mjs`
path only resolves correctly when the server process working directory is the installed plugin root.

Generate the bundled file from:

```text
C:\Users\LilianCambillau\source\repos\UptalePlatform\McpServer
```

by running:

```powershell
pnpm run bundle:plugin
```

That creates `build/uptale-mcp.mjs` in the MCP project. Copy that file into
[`plugins/uptale-creator/mcp/uptale-mcp.mjs`](plugins/uptale-creator/mcp/uptale-mcp.mjs) when
updating the plugin. It is intended to be
self-contained for the platform used to build it and does not require plugin-local `node_modules` or
`mcp/package.json`.

Default environment:

```json
{
  "UPTALE_MCP_ENVIRONMENT": "dev"
}
```

To change the environment, edit
[`plugins/uptale-creator/.mcp.json`](plugins/uptale-creator/.mcp.json) and set
`UPTALE_MCP_ENVIRONMENT`.

## Static Check

After copying the MCP bundle into the plugin, run:

```powershell
node --check .\plugins\uptale-creator\mcp\uptale-mcp.mjs
```

That checks the generated file syntax.

## Skill Planning

The proposed skill architecture is documented in
[`plugins/uptale-creator/docs/skills-roadmap.md`](plugins/uptale-creator/docs/skills-roadmap.md). It separates the conversation workflow, Uptale
tag/exercise references, MCP application, live review, media planning, final deliverables, and 360
mockup prompting.
