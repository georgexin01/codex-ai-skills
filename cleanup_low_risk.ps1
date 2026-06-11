param(
    [switch]$Execute
)

$root = Split-Path -Parent $MyInvocation.MyCommand.Path

# Low-risk paths relative to the .codex root
$relPaths = @(
    '.codex-global-state.json.bak',
    '.tmp',
    'tmp',
    'cache',
    'ambient-suggestions',
    'plugins/cache',
    'models_cache.json',
    'vendor_imports/skills/skills/.curated',
    'vendor_imports/skills/skills-curated-cache.json'
)

$fullPaths = $relPaths | ForEach-Object { Join-Path $root $_ }
$existing = $fullPaths | Where-Object { Test-Path $_ }

if (-not $existing) {
    Write-Output "No low-risk files or folders found to archive/remove."
    return 0
}

$ts = Get-Date -Format "yyyyMMdd-HHmmss"
$archiveDir = Join-Path $root 'tmp'
if (-not (Test-Path $archiveDir)) { New-Item -Path $archiveDir -ItemType Directory | Out-Null }
$archivePath = Join-Path $archiveDir "cleanup-archive-$ts.zip"

Write-Output "Found the following existing low-risk items:"
$existing | ForEach-Object { Write-Output " - $_" }

if (-not $Execute) {
    Write-Output "\nDRY RUN: no changes made. To perform deletion, re-run with -Execute."
    Write-Output "Archive that WOULD be created: $archivePath"
    exit 0
}

Write-Output "Creating archive: $archivePath"
try {
    Compress-Archive -Path $existing -DestinationPath $archivePath -Force -ErrorAction Stop
}
catch {
    Write-Error "Failed to create archive: $_"
    exit 1
}

Write-Output "Archive created successfully. Removing original items..."
foreach ($p in $existing) {
    try {
        Remove-Item -LiteralPath $p -Recurse -Force -ErrorAction Stop
        Write-Output "Removed: $p"
    }
    catch {
        Write-Error "Failed to remove $p : $_"
    }
}

Write-Output "Cleanup complete. Archive saved to: $archivePath"
