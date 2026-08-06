#!/bin/sh
set -eu

runtime_node="$HOME/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/bin/node"

if [ ! -x "$runtime_node" ]; then
    runtime_node="$HOME/Library/Caches/codex-runtimes/codex-primary-runtime/dependencies/node/bin/node"
fi

if [ ! -x "$runtime_node" ]; then
    echo "Uptale MCP could not locate Codex's managed Node.js runtime." >&2
    exit 1
fi

exec "$runtime_node" "uptale-mcp.mjs"
