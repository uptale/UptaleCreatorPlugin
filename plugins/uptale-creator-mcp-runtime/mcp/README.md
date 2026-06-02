# Uptale MCP Runtime

This folder is the shared source copy of the bundled MCP server generated from:

`C:\Users\LilianCambillau\source\repos\UptalePlatform\McpServer`

Each environment plugin runs the bundle from its own `mcp/` folder:

```powershell
node uptale-mcp.mjs
```

Both hosts now load the bundle plugin-locally: Codex via `.mcp.json` (`cwd: "./mcp"`) and Claude
Code via `mcp.claude.json` (`${CLAUDE_PLUGIN_ROOT}/mcp/uptale-mcp.mjs`). This folder is no longer
referenced at runtime; it is the source from which the bundle is copied into each env plugin's
`mcp/` folder (see the repo root README for the update steps).

## Expected Layout

The useful runtime layout is:

```text
mcp/
  uptale-mcp.mjs
```

To generate it in the MCP project, run:

```powershell
pnpm run bundle:plugin
```

Then copy `build/uptale-mcp.mjs` from the MCP project to `mcp/uptale-mcp.mjs` in this shared runtime
folder.

`uptale-mcp.mjs` is a single-file bundle. It embeds the installed keyring native binary and extracts
that binary to a temp folder at runtime.

## Environment

`.mcp.json` sets `UPTALE_MCP_ENVIRONMENT`. Supported values are:

- `dev`
- `stg`
- `prod-eu`
- `prod-us`

The MCP server exposes OAuth login through the `uptale_login` tool, then stores tokens securely for
later API calls.
