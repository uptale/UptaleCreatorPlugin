$ErrorActionPreference = "Stop"

$SourceMcpDir = Join-Path $PSScriptRoot "..\plugins\uptale-creator-mcp-runtime\mcp"
$TargetPluginDirs = @(
    (Join-Path $PSScriptRoot "..\plugins\uptale-creator-dev"),
    (Join-Path $PSScriptRoot "..\plugins\uptale-creator-stg"),
    (Join-Path $PSScriptRoot "..\plugins\uptale-creator-prod-eu"),
    (Join-Path $PSScriptRoot "..\plugins\uptale-creator-prod-us")
)

function Resolve-ExistingPath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    if (-not (Test-Path -LiteralPath $Path)) {
        throw "Path not found: $Path"
    }

    return (Resolve-Path -LiteralPath $Path).Path
}

function Copy-McpItem {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Source,
        [Parameter(Mandatory = $true)]
        [string]$Destination
    )

    $parent = Split-Path -Parent $Destination
    if (-not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent | Out-Null
    }

    $sourceItem = Get-Item -LiteralPath $Source

    if ($sourceItem.PSIsContainer) {
        if (-not (Test-Path -LiteralPath $Destination)) {
            New-Item -ItemType Directory -Path $Destination | Out-Null
        }

        Get-ChildItem -LiteralPath $Source -Force | ForEach-Object {
            Copy-Item -LiteralPath $_.FullName -Destination $Destination -Recurse -Force
        }
    }
    else {
        Copy-Item -LiteralPath $Source -Destination $Destination -Force
    }
}

$resolvedSourceMcpDir = Resolve-ExistingPath $SourceMcpDir
$sourceBundle = Join-Path $resolvedSourceMcpDir "uptale-mcp.mjs"
$sourceNodeModules = Join-Path $resolvedSourceMcpDir "node_modules"

if (-not (Test-Path -LiteralPath $sourceBundle)) {
    throw "Source bundle not found: $sourceBundle"
}

Write-Host "Deploying MCP runtime from: $resolvedSourceMcpDir"

$deployedBundles = @($sourceBundle)

foreach ($targetPluginDir in $TargetPluginDirs) {
    $resolvedTargetPluginDir = Resolve-ExistingPath $targetPluginDir
    $targetMcpDir = Join-Path $resolvedTargetPluginDir "mcp"
    $targetBundle = Join-Path $targetMcpDir "uptale-mcp.mjs"

    Copy-McpItem -Source $sourceBundle -Destination $targetBundle
    $deployedBundles += $targetBundle

    if (Test-Path -LiteralPath $sourceNodeModules) {
        Copy-McpItem -Source $sourceNodeModules -Destination (Join-Path $targetMcpDir "node_modules")
    }
    else {
        Write-Warning "No node_modules folder found in source. Skipping dependency copy."
    }

    Write-Host "Updated: $targetMcpDir"
}

foreach ($bundle in $deployedBundles) {
    Write-Host "Checking: $bundle"
    node --check $bundle
}

Write-Host "MCP deploy complete."
