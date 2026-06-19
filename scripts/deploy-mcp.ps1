param(
    [switch]$SkipVersionBump
)

$ErrorActionPreference = "Stop"

$SourceMcpDir = Join-Path $PSScriptRoot "..\plugins\uptale-creator-mcp-runtime\mcp"
$TargetPluginDirs = @(
    (Join-Path $PSScriptRoot "..\plugins\uptale-creator-dev"),
    (Join-Path $PSScriptRoot "..\plugins\uptale-creator-stg"),
    (Join-Path $PSScriptRoot "..\plugins\uptale-creator-prod-eu"),
    (Join-Path $PSScriptRoot "..\plugins\uptale-creator-prod-us")
)

$ManifestRelativePaths = @(
    "plugins\uptale-creator-dev\.codex-plugin\plugin.json",
    "plugins\uptale-creator-dev\.claude-plugin\plugin.json",
    "plugins\uptale-creator-stg\.codex-plugin\plugin.json",
    "plugins\uptale-creator-stg\.claude-plugin\plugin.json",
    "plugins\uptale-creator-prod-eu\.codex-plugin\plugin.json",
    "plugins\uptale-creator-prod-eu\.claude-plugin\plugin.json",
    "plugins\uptale-creator-prod-us\.codex-plugin\plugin.json",
    "plugins\uptale-creator-prod-us\.claude-plugin\plugin.json"
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

function Get-NextPatchVersion {
    param(
        [Parameter(Mandatory = $true)]
        [string]$CurrentVersion
    )

    $parts = $CurrentVersion.Split(".")
    if ($parts.Count -ne 3) {
        throw "Cannot bump version '$CurrentVersion'. Expected a version like 0.1.6."
    }

    $major = 0
    $minor = 0
    $patch = 0
    if (
        -not [int]::TryParse($parts[0], [ref]$major) -or
        -not [int]::TryParse($parts[1], [ref]$minor) -or
        -not [int]::TryParse($parts[2], [ref]$patch)
    ) {
        throw "Cannot bump version '$CurrentVersion'. All parts must be integers."
    }

    return "$major.$minor.$($patch + 1)"
}

function Update-ManifestVersion {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,
        [Parameter(Mandatory = $true)]
        [string]$Version
    )

    $content = Get-Content -LiteralPath $Path -Raw
    $updatedContent = $content -replace '("version"\s*:\s*")[^"]+(")', "`${1}$Version`${2}"
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false); [System.IO.File]::WriteAllText($Path, $updatedContent, $utf8NoBom)
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

if (-not $SkipVersionBump) {
    $pluginRoot = Resolve-ExistingPath (Join-Path $PSScriptRoot "..")
    $manifestPaths = $ManifestRelativePaths | ForEach-Object { Join-Path $pluginRoot $_ }
    $firstManifest = Resolve-ExistingPath $manifestPaths[0]
    $firstManifestContent = Get-Content -LiteralPath $firstManifest -Raw | ConvertFrom-Json
    $nextVersion = Get-NextPatchVersion $firstManifestContent.version

    foreach ($manifestPath in $manifestPaths) {
        $resolvedManifestPath = Resolve-ExistingPath $manifestPath
        Update-ManifestVersion -Path $resolvedManifestPath -Version $nextVersion
        Write-Host "Updated manifest version: $resolvedManifestPath -> $nextVersion"
    }
}
else {
    Write-Host "Skipping manifest version bump."
}

Write-Host "MCP deploy complete."
