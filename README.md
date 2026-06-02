# UptaleCreatorPlugin

Plugin scaffold for Uptale creators to design immersive storyboards and operate Uptale experiences
through environment-specific plugin-local MCP servers.

## Marketplaces

This repository ships **two** marketplace manifests so the same plugins can be installed from
either Codex or Claude Code:

- Codex marketplace: [`.agents/plugins/marketplace.json`](.agents/plugins/marketplace.json)
- Claude Code marketplace: [`.claude-plugin/marketplace.json`](.claude-plugin/marketplace.json)

In Claude Code:

```text
/plugin marketplace add <path-or-git-url-of-this-repo>
/plugin install uptale-creator-skills@uptale-creator
/plugin install uptale-creator-dev@uptale-creator
```

Both marketplaces expose the same five plugins so skills can be installed independently from the
MCP environment:

- [`uptale-creator-skills`](plugins/uptale-creator-skills): Uptale scenario, review, MCP planning,
  deliverable, media planning, reference, and 360 mockup skills.
- [`uptale-creator-dev`](plugins/uptale-creator-dev): MCP server configured for `dev`.
- [`uptale-creator-stg`](plugins/uptale-creator-stg): MCP server configured for `stg`.
- [`uptale-creator-prod-eu`](plugins/uptale-creator-prod-eu): MCP server configured for `prod-eu`.
- [`uptale-creator-prod-us`](plugins/uptale-creator-prod-us): MCP server configured for `prod-us`.

## MCP Runtime

Each env plugin runs the bundled `uptale-mcp.mjs` MCP server with `UPTALE_MCP_ENVIRONMENT` fixed
per-plugin (so users install the environment they want instead of editing config).

Both hosts now load the bundle from each env plugin's own `mcp/` folder:

- **Codex** uses [`.mcp.json`](plugins/uptale-creator-dev/.mcp.json) with `cwd: "./mcp"`. Codex
  resolves that relative to the env plugin folder, so it runs the plugin-local bundle at
  [`plugins/uptale-creator-dev/mcp/uptale-mcp.mjs`](plugins/uptale-creator-dev/mcp/uptale-mcp.mjs).
- **Claude Code** copies each plugin into a per-plugin install cache and refuses paths that
  traverse outside the plugin root. Each env plugin carries its own copy of the bundle and its
  `node_modules` at `plugins/uptale-creator-<env>/mcp/`, and
  [`mcp.claude.json`](plugins/uptale-creator-dev/mcp.claude.json) references it via
  `${CLAUDE_PLUGIN_ROOT}/mcp/uptale-mcp.mjs`.

The bundle marks `@napi-rs/keyring` as an external import and resolves it from `node_modules` at
runtime, so the `mcp/node_modules/@napi-rs/{keyring,keyring-win32-x64-msvc}` packages must sit next
to `uptale-mcp.mjs` in every env plugin folder.

Net result: each env plugin is self-contained for both hosts. The shared
[`plugins/uptale-creator-mcp-runtime/mcp`](plugins/uptale-creator-mcp-runtime/mcp) folder is no
longer referenced at runtime; it stays as the shared source copy from which the bundle is fanned out to
each env plugin. Updating the bundle requires refreshing the shared runtime and every env plugin
(see below).

## Updating the bundle

Generate the bundle from:

```text
C:\Users\LilianCambillau\source\repos\UptalePlatform\McpServer
```

by running:

```powershell
pnpm run bundle:plugin
```

That creates `build/uptale-mcp.mjs` in the MCP project. Copy it once into the shared runtime:

```powershell
copy build\uptale-mcp.mjs plugins\uptale-creator-mcp-runtime\mcp\uptale-mcp.mjs
```

Then fan it out to every env plugin:

```powershell
.\scripts\deploy-mcp.ps1
```

By default, the script copies the shared runtime bundle from
`plugins\uptale-creator-mcp-runtime\mcp` into:

- `plugins\uptale-creator-dev\mcp`
- `plugins\uptale-creator-stg\mcp`
- `plugins\uptale-creator-prod-eu\mcp`
- `plugins\uptale-creator-prod-us\mcp`

It also copies `node_modules` when that folder exists next to the shared runtime bundle, then runs
`node --check` against the shared bundle and every copied bundle.

## Static Check

The deploy script runs this automatically. To check bundles manually:

```powershell
node --check .\plugins\uptale-creator-mcp-runtime\mcp\uptale-mcp.mjs
node --check .\plugins\uptale-creator-dev\mcp\uptale-mcp.mjs
node --check .\plugins\uptale-creator-stg\mcp\uptale-mcp.mjs
node --check .\plugins\uptale-creator-prod-eu\mcp\uptale-mcp.mjs
node --check .\plugins\uptale-creator-prod-us\mcp\uptale-mcp.mjs
```

## Skill Planning

The proposed skill architecture is documented in
[`plugins/uptale-creator-skills/docs/skills-roadmap.md`](plugins/uptale-creator-skills/docs/skills-roadmap.md). It separates the conversation workflow, Uptale
tag/exercise references, MCP application, live review, media planning, final deliverables, and 360
mockup prompting.
