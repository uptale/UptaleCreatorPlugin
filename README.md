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

Both marketplaces expose the same four plugins so skills can be installed independently from the
MCP environment:

- [`uptale-creator-skills`](plugins/uptale-creator-skills): Uptale scenario, review, MCP planning,
  deliverable, media planning, reference, and 360 mockup skills.
- [`uptale-creator-dev`](plugins/uptale-creator-dev): MCP server configured for `dev`.
- [`uptale-creator-prod-eu`](plugins/uptale-creator-prod-eu): MCP server configured for `prod-eu`.
- [`uptale-creator-prod-us`](plugins/uptale-creator-prod-us): MCP server configured for `prod-us`.

## MCP Runtime

Each env plugin runs the bundled `uptale-mcp.mjs` MCP server with `UPTALE_MCP_ENVIRONMENT` fixed
per-plugin (so users install the environment they want instead of editing config).

The runtime is wired differently per host because of how each host loads plugin files:

- **Codex** uses [`.mcp.json`](plugins/uptale-creator-dev/.mcp.json) with
  `cwd: "../uptale-creator-mcp-runtime/mcp"`. Codex resolves that relative to the env plugin folder,
  so all three env plugins share the single bundle at
  [`plugins/uptale-creator-mcp-runtime/mcp/uptale-mcp.mjs`](plugins/uptale-creator-mcp-runtime/mcp/uptale-mcp.mjs).
- **Claude Code** copies each plugin into a per-plugin install cache and refuses paths that
  traverse outside the plugin root. To work around this, each env plugin carries its own copy of
  the bundle and its `node_modules` at `plugins/uptale-creator-<env>/mcp/`, and
  [`mcp.claude.json`](plugins/uptale-creator-dev/mcp.claude.json) references it via
  `${CLAUDE_PLUGIN_ROOT}/mcp/uptale-mcp.mjs`.

The bundle marks `@napi-rs/keyring` as an external import and resolves it from `node_modules` at
runtime, so the `mcp/node_modules/@napi-rs/{keyring,keyring-win32-x64-msvc}` packages must sit next
to `uptale-mcp.mjs` in every env plugin folder.

Net result: one source of truth for Codex; for Claude Code the same bundle (and its keyring
modules) is duplicated into each env plugin folder. Updating the bundle requires refreshing all
four locations (see below).

## Updating the bundle

Generate the bundle from:

```text
C:\Users\LilianCambillau\source\repos\UptalePlatform\McpServer
```

by running:

```powershell
pnpm run bundle:plugin
```

That creates `build/uptale-mcp.mjs` in the MCP project. Copy it into all four locations:

```powershell
copy build\uptale-mcp.mjs plugins\uptale-creator-mcp-runtime\mcp\uptale-mcp.mjs
copy build\uptale-mcp.mjs plugins\uptale-creator-dev\mcp\uptale-mcp.mjs
copy build\uptale-mcp.mjs plugins\uptale-creator-prod-eu\mcp\uptale-mcp.mjs
copy build\uptale-mcp.mjs plugins\uptale-creator-prod-us\mcp\uptale-mcp.mjs
```

If you ever upgrade the keyring dependency, also resync `node_modules` from the shared runtime into
each env plugin:

```powershell
robocopy plugins\uptale-creator-mcp-runtime\mcp\node_modules plugins\uptale-creator-dev\mcp\node_modules /MIR
robocopy plugins\uptale-creator-mcp-runtime\mcp\node_modules plugins\uptale-creator-prod-eu\mcp\node_modules /MIR
robocopy plugins\uptale-creator-mcp-runtime\mcp\node_modules plugins\uptale-creator-prod-us\mcp\node_modules /MIR
```

## Static Check

After copying, syntax-check every bundle:

```powershell
node --check .\plugins\uptale-creator-mcp-runtime\mcp\uptale-mcp.mjs
node --check .\plugins\uptale-creator-dev\mcp\uptale-mcp.mjs
node --check .\plugins\uptale-creator-prod-eu\mcp\uptale-mcp.mjs
node --check .\plugins\uptale-creator-prod-us\mcp\uptale-mcp.mjs
```

## Skill Planning

The proposed skill architecture is documented in
[`plugins/uptale-creator-skills/docs/skills-roadmap.md`](plugins/uptale-creator-skills/docs/skills-roadmap.md). It separates the conversation workflow, Uptale
tag/exercise references, MCP application, live review, media planning, final deliverables, and 360
mockup prompting.
