# UptaleCreatorPlugin

Plugin scaffold for Uptale creators to design immersive storyboards and operate Uptale experiences
through environment-specific plugin-local MCP servers.

## Git Marketplace

This repository includes a Codex marketplace file at
[`.agents/plugins/marketplace.json`](.agents/plugins/marketplace.json). Add this repository as a Git
marketplace in Codex to install the Uptale skill and MCP environment plugins.

The marketplace exposes separate plugins so skills can be installed independently from the MCP
environment:

- [`uptale-creator-skills`](plugins/uptale-creator-skills): Uptale scenario, review, MCP planning,
  deliverable, media planning, reference, and 360 mockup skills.
- [`uptale-creator-dev`](plugins/uptale-creator-dev): MCP server configured for `dev`.
- [`uptale-creator-prod-eu`](plugins/uptale-creator-prod-eu): MCP server configured for `prod-eu`.
- [`uptale-creator-prod-us`](plugins/uptale-creator-prod-us): MCP server configured for `prod-us`.

The shared bundled MCP runtime lives once in
[`plugins/uptale-creator-mcp-runtime/mcp`](plugins/uptale-creator-mcp-runtime/mcp). The environment
plugins only contain manifests and `.mcp.json` files that point to that shared runtime.

## MCP Runtime

Each MCP plugin is wired to load one MCP server from its own `.mcp.json`. The configured servers
are `uptale-dev`, `uptale-prod-eu`, and `uptale-prod-us`, and each runs the shared bundled MCP file:

```powershell
node uptale-mcp.mjs
```

The MCP config sets `cwd` to `../uptale-creator-mcp-runtime/mcp`. Keep that in place: Codex may
start bundled MCP servers from the current workspace or app process directory, and the relative
`uptale-mcp.mjs` path only resolves correctly when the server process working directory is the
shared runtime MCP directory.

Generate the bundled file from:

```text
C:\Users\LilianCambillau\source\repos\UptalePlatform\McpServer
```

by running:

```powershell
pnpm run bundle:plugin
```

That creates `build/uptale-mcp.mjs` in the MCP project. Copy that file into the shared runtime when
updating the plugin:

[`plugins/uptale-creator-mcp-runtime/mcp/uptale-mcp.mjs`](plugins/uptale-creator-mcp-runtime/mcp/uptale-mcp.mjs)

The MCP environment is fixed per plugin through `UPTALE_MCP_ENVIRONMENT`, so users install the
environment they want instead of editing `.mcp.json`.

## Static Check

After copying the MCP bundle into the plugin, run:

```powershell
node --check .\plugins\uptale-creator-mcp-runtime\mcp\uptale-mcp.mjs
```

That checks the generated file syntax.

## Skill Planning

The proposed skill architecture is documented in
[`plugins/uptale-creator-skills/docs/skills-roadmap.md`](plugins/uptale-creator-skills/docs/skills-roadmap.md). It separates the conversation workflow, Uptale
tag/exercise references, MCP application, live review, media planning, final deliverables, and 360
mockup prompting.
