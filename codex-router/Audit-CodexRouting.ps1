param(
  [switch]$Quiet
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$codexRoot = Split-Path -Parent $scriptDir
$configPath = Join-Path $scriptDir "router-config.json"
$dynamicPath = Join-Path $codexRoot "CODEX_DYNAMIC_ROUTING.md"

if (-not (Test-Path -LiteralPath $configPath)) {
  throw "Missing router config: $configPath"
}

$config = Get-Content -LiteralPath $configPath -Raw | ConvertFrom-Json

function Resolve-RepoPath([string]$relativePath) {
  Join-Path $codexRoot $relativePath
}

function Test-IsExcluded([string]$fullPath) {
  $relative = ($fullPath.Replace($codexRoot, "").TrimStart('\','/')) -replace '\\','/'
  foreach ($pat in @($config.exclude)) {
    if (-not $pat) { continue }
    $normalizedPattern = (([string]$pat) -replace '\\','/') -replace '\*\*','*'
    if ($relative -like $normalizedPattern) { return $true }
  }
  return $false
}

$mandatory = @(
  "00_CODEX_START_HERE.md",
  "00_CODEX_CUSTOM_INSTRUCTIONS_CODEX_BRIDGE.md",
  "00_REASONING_EVOLUTION_PROTOCOL.md",
  "CODEX_FULL_ACCESS_ROUTING.md",
  "CODEX_DYNAMIC_ROUTING.md"
)
$mandatory += @($config.tier_map.tier_0)
$mandatory += @($config.tier_map.tier_1)
$mandatory += @($config.tier_map.tier_2)
$mandatory = $mandatory | Where-Object { $_ -and $_.Trim().Length -gt 0 } | Select-Object -Unique

$missingMandatory = @()
foreach ($rel in $mandatory) {
  $abs = Resolve-RepoPath $rel
  if (-not (Test-Path -LiteralPath $abs)) { $missingMandatory += $abs }
}

$missingFallback = @()
foreach ($rel in @($config.fallback_chain)) {
  $abs = Resolve-RepoPath $rel
  if (-not (Test-Path -LiteralPath $abs)) { $missingFallback += $abs }
}

$missingRoots = @()
foreach ($root in @($config.roots)) {
  $abs = Resolve-RepoPath $root.path
  if (-not (Test-Path -LiteralPath $abs)) { $missingRoots += $abs }
}

# ROUTER.idx / ATLAS.idx audit retired — codex-router/codex-manifest.json is the index of record.

$scanFiles = @(
  (Join-Path $codexRoot "00_CODEX_START_HERE.md"),
  (Join-Path $codexRoot "00_CODEX_CUSTOM_INSTRUCTIONS_CODEX_BRIDGE.md"),
  (Join-Path $codexRoot "CODEX_FULL_ACCESS_ROUTING.md"),
  (Join-Path $codexRoot "AGENTS.md")
)
$scanFiles += (Get-ChildItem -LiteralPath (Join-Path $codexRoot "memories") -Recurse -File -ErrorAction SilentlyContinue |
  Where-Object { @(".md",".yaml",".yml",".json",".ps1",".txt",".idx",".toml") -contains $_.Extension.ToLowerInvariant() -and -not (Test-IsExcluded $_.FullName) }).FullName
$scanFiles += (Get-ChildItem -LiteralPath (Join-Path $codexRoot "skills") -Recurse -File -ErrorAction SilentlyContinue |
  Where-Object { @(".md",".yaml",".yml",".json",".ps1",".txt",".idx",".toml") -contains $_.Extension.ToLowerInvariant() -and $_.FullName -notmatch "\\faucet\\" -and -not (Test-IsExcluded $_.FullName) }).FullName
$scanFiles = $scanFiles | Sort-Object -Unique

$legacyPattern = "\\.gemini|gemini-3-flash|gemini-3-pro|Gemini-3-Flash|Gemini-3-Pro"
$legacyRefs = New-Object System.Collections.Generic.List[string]
foreach ($f in $scanFiles) {
  try {
    $hits = Select-String -LiteralPath $f -Pattern $legacyPattern -ErrorAction SilentlyContinue
    foreach ($h in $hits) {
      $legacyRefs.Add(("{0}:{1}" -f $f, $h.LineNumber))
    }
  } catch {}
}

$summary = [pscustomobject]@{
  generated_utc = [DateTime]::UtcNow.ToString("o")
  codex_root = $codexRoot
  missing_mandatory_count = $missingMandatory.Count
  missing_fallback_count = $missingFallback.Count
  missing_roots_count = $missingRoots.Count
  legacy_ref_count = $legacyRefs.Count
  missing_mandatory = $missingMandatory
  missing_fallback = $missingFallback
  missing_roots = $missingRoots
  legacy_refs = $legacyRefs
}

if (-not $Quiet) {
  $summary | ConvertTo-Json -Depth 6
}
