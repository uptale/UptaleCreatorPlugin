# Uptale MCP Runtime

This folder contains the plugin-local bundled MCP server copied from:

`C:\Users\LilianCambillau\source\repos\UptalePlatform\McpServer`

Each environment plugin MCP config runs:

```powershell
node uptale-mcp.mjs
```

`.mcp.json` sets `cwd` to `../uptale-creator-mcp-runtime/mcp` so `uptale-mcp.mjs` resolves from
this shared runtime directory, not from the user's current workspace.

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
- `prod-eu`
- `prod-us`

The MCP server exposes OAuth login through the `uptale_login` tool, then stores tokens securely for
later API calls.
