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
/plugin install uptale-creator-dev-macos@uptale-creator
```

Both marketplaces expose the skills plugin plus the four Windows and four macOS environment plugins,
so skills can be installed independently from the MCP environment:

- [`uptale-creator-skills`](plugins/uptale-creator-skills): Uptale scenario, review, MCP planning,
  deliverable, media planning, reference, and 360 mockup skills.
- [`uptale-creator-dev`](plugins/uptale-creator-dev): Windows MCP server configured for `dev`.
- [`uptale-creator-stg`](plugins/uptale-creator-stg): Windows MCP server configured for `stg`.
- [`uptale-creator-prod-eu`](plugins/uptale-creator-prod-eu): Windows MCP server configured for `prod-eu`.
- [`uptale-creator-prod-us`](plugins/uptale-creator-prod-us): Windows MCP server configured for `prod-us`.
- [`uptale-creator-dev-macos`](plugins/uptale-creator-dev-macos): macOS MCP server configured for `dev`.
- [`uptale-creator-stg-macos`](plugins/uptale-creator-stg-macos): macOS MCP server configured for `stg`.
- [`uptale-creator-prod-eu-macos`](plugins/uptale-creator-prod-eu-macos): macOS MCP server configured for `prod-eu`.
- [`uptale-creator-prod-us-macos`](plugins/uptale-creator-prod-us-macos): macOS MCP server configured for `prod-us`.

Install the entry without the `-macos` suffix on Windows and the matching `-macos` entry on macOS.
Do not install both OS variants for the same environment. In Codex, macOS users do not need to
install Node.js because the launcher uses Codex's managed Node.js runtime. In Claude Code, the
macOS variants use `node` from `PATH`. The bundled keyring packages support both Apple Silicon and
Intel Macs.

Each environment has its own neon badge (`DEV`, `STG`, `PROD EU`, or `PROD US`) beneath the Uptale
mini mark. The Windows and macOS variants of the same environment use the same artwork.

## MCP Runtime

Each env plugin runs the bundled `uptale-mcp.mjs` MCP server with `UPTALE_MCP_ENVIRONMENT` fixed
per-plugin (so users install the environment they want instead of editing config).

Both hosts now load the bundle from each env plugin's own `mcp/` folder:

- **Codex on Windows** uses [`.mcp.json`](plugins/uptale-creator-dev/.mcp.json) with
  `cwd: "./mcp"`. Codex resolves that relative to the env plugin folder, so it runs the plugin-local
  bundle at [`plugins/uptale-creator-dev/mcp/uptale-mcp.mjs`](plugins/uptale-creator-dev/mcp/uptale-mcp.mjs).
- **Codex on macOS** uses the corresponding `-macos` plugin and
  [`start-mcp-macos.sh`](plugins/uptale-creator-mcp-runtime/mcp/start-mcp-macos.sh) to locate Codex's
  managed Node.js runtime. The launcher is invoked through `/bin/sh`, so it does not require
  executable file permissions.
- **Claude Code** copies each plugin into a per-plugin install cache and refuses paths that
  traverse outside the plugin root. All Windows and macOS env plugins carry their own copy of the
  bundle and `node_modules` under `mcp/`, and
  [`mcp.claude.json`](plugins/uptale-creator-dev/mcp.claude.json) references it via
  `${CLAUDE_PLUGIN_ROOT}/mcp/uptale-mcp.mjs`. Claude Code launches it with `node`, so Node.js must
  be available on `PATH` on both platforms.

The bundle marks `@napi-rs/keyring` as an external import and resolves it from `node_modules` at
runtime. The `mcp/node_modules/@napi-rs/keyring` package and the platform packages for Windows x64,
macOS x64, and macOS arm64 must sit next to `uptale-mcp.mjs` in every env plugin folder.

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

The same bundle, dependencies, and macOS launcher are also copied into the `mcp/` folders of
`uptale-creator-dev-macos`, `uptale-creator-stg-macos`, `uptale-creator-prod-eu-macos`, and
`uptale-creator-prod-us-macos`.

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
node --check .\plugins\uptale-creator-dev-macos\mcp\uptale-mcp.mjs
node --check .\plugins\uptale-creator-stg-macos\mcp\uptale-mcp.mjs
node --check .\plugins\uptale-creator-prod-eu-macos\mcp\uptale-mcp.mjs
node --check .\plugins\uptale-creator-prod-us-macos\mcp\uptale-mcp.mjs
/bin/sh -n ./plugins/uptale-creator-mcp-runtime/mcp/start-mcp-macos.sh
```

## Skill Planning

The proposed skill architecture is documented in
[`plugins/uptale-creator-skills/docs/skills-roadmap.md`](plugins/uptale-creator-skills/docs/skills-roadmap.md). It separates the conversation workflow, Uptale
tag/exercise references, MCP application, live review, media planning, final deliverables, and 360
mockup prompting.
