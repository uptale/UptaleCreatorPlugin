# Uptale MCP Runtime

This folder is the plugin-local drop zone for the built MCP server from:

`C:\Users\LilianCambillau\source\repos\UptalePlatform\McpServer`

The plugin MCP config runs:

```powershell
node ./scripts/run-uptale-mcp.mjs
```

## Expected Layout

After pasting the built MCP runtime, the minimum useful layout is:

```text
mcp/
  build/
    index.js
    ...
  package.json
  node_modules/        # required if dependencies are not bundled into build/
```

The checked-in `package.json` mirrors the current MCP runtime dependencies so you can paste only
`build/` first, then install production dependencies in this folder if the pasted build is not
self-contained.

## Environment

The launcher resolves `UPTALE_MCP_ENVIRONMENT` in this order:

1. A value already provided by the host process.
2. `mcp/runtime-config.json`, if present.
3. The launcher default, currently `prod-eu`.

Set the per-install value with:

```powershell
.\scripts\set-mcp-environment.ps1 prod-eu
```

Supported values are:

- `dev`
- `prod-eu`
- `prod-us`
- `local`

`.mcp.json` keeps the Node CA setting:

```json
{
  "NODE_OPTIONS": "--use-system-ca"
}
```

The MCP server exposes OAuth login through the `uptale_login` tool, then stores tokens securely for
later API calls.
