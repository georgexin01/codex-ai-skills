param(
  [switch]$Json
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$codexRoot = Split-Path -Parent $scriptDir
$benchmarkPath = Join-Path $scriptDir "perf-benchmark.json"
$dynamicPath = Join-Path $codexRoot "CODEX_DYNAMIC_ROUTING.md"
$manifestPath = Join-Path $scriptDir "codex-manifest.json"
$auditPath = Join-Path $scriptDir "Audit-CodexRouting.ps1"

function Read-Text([string]$Path) {
  if (-not (Test-Path -LiteralPath $Path)) { throw "Missing file: $Path" }
  Get-Content -LiteralPath $Path -Raw
}

function Add-Result([System.Collections.Generic.List[object]]$Results, [string]$Id, [bool]$Passed, [string]$Detail) {
  $Results.Add([pscustomobject]@{
    id = $Id
    passed = $Passed
    detail = $Detail
  })
}

if (-not (Test-Path -LiteralPath $benchmarkPath)) {
  throw "Missing benchmark config: $benchmarkPath"
}

$benchmark = Read-Text $benchmarkPath | ConvertFrom-Json
$dynamic = Read-Text $dynamicPath
$manifest = Read-Text $manifestPath | ConvertFrom-Json
$results = New-Object System.Collections.Generic.List[object]

$safeIndexed = 0
if ($dynamic -match "Safe indexed files:\s*(\d+)") { $safeIndexed = [int]$Matches[1] }
$knowledgeRoutes = 0
if ($dynamic -match "knowledge:\s*(\d+)\s+files") { $knowledgeRoutes = [int]$Matches[1] }

Add-Result $results "target-safe-indexed-files" ($safeIndexed -le [int]$benchmark.targets.max_safe_indexed_files) "safe_indexed=$safeIndexed max=$($benchmark.targets.max_safe_indexed_files)"
Add-Result $results "target-knowledge-routes" ($knowledgeRoutes -le [int]$benchmark.targets.max_knowledge_routes) "knowledge_routes=$knowledgeRoutes max=$($benchmark.targets.max_knowledge_routes)"

$auditJson = & powershell -ExecutionPolicy Bypass -File $auditPath | ConvertFrom-Json
$missingTotal = [int]$auditJson.missing_mandatory_count + [int]$auditJson.missing_fallback_count + [int]$auditJson.missing_roots_count
Add-Result $results "audit-missing-entries" ($missingTotal -le [int]$benchmark.targets.max_missing_entries) "missing_total=$missingTotal"
Add-Result $results "audit-legacy-refs-budget" ([int]$auditJson.legacy_ref_count -le [int]$benchmark.targets.max_legacy_refs) "legacy_refs=$($auditJson.legacy_ref_count) max=$($benchmark.targets.max_legacy_refs)"

foreach ($case in $benchmark.cases) {
  $caseText = $dynamic
  if ($case.file) {
    $casePath = Join-Path $codexRoot ([string]$case.file)
    $caseText = Read-Text $casePath
  }

  $failures = New-Object System.Collections.Generic.List[string]

  if ($case.PSObject.Properties.Name -contains "expect_contains") {
    foreach ($needle in @($case.expect_contains)) {
      if ([string]::IsNullOrWhiteSpace([string]$needle)) { continue }
      if ($caseText -notlike "*$needle*") { $failures.Add("missing: $needle") }
    }
  }

  if ($case.PSObject.Properties.Name -contains "expect_not_contains") {
    foreach ($needle in @($case.expect_not_contains)) {
      if ([string]::IsNullOrWhiteSpace([string]$needle)) { continue }
      if ($caseText -like "*$needle*") { $failures.Add("unexpected: $needle") }
    }
  }

  if ($case.PSObject.Properties.Name -contains "manifest_forbidden_paths") {
    foreach ($forbidden in @($case.manifest_forbidden_paths)) {
      if ([string]::IsNullOrWhiteSpace([string]$forbidden)) { continue }
      $hit = $false
      foreach ($entry in @($manifest.entries)) {
        if ([string]$entry.relative_path -like "*$forbidden*") {
          $hit = $true
          break
        }
      }
      if ($hit) { $failures.Add("manifest still indexes: $forbidden") }
    }
  }

  Add-Result $results ([string]$case.id) ($failures.Count -eq 0) ($(if ($failures.Count -eq 0) { "ok" } else { $failures -join "; " }))
}

$passed = @($results | Where-Object passed).Count
$failed = @($results | Where-Object { -not $_.passed }).Count
$score = if (($passed + $failed) -gt 0) { [math]::Round(($passed / ($passed + $failed)) * 10, 1) } else { 0 }

$summary = [pscustomobject]@{
  generated_utc = [DateTime]::UtcNow.ToString("o")
  safe_indexed_files = $safeIndexed
  knowledge_routes = $knowledgeRoutes
  passed = $passed
  failed = $failed
  rating_10 = $score
  results = $results
}

if ($Json) {
  $summary | ConvertTo-Json -Depth 8
} else {
  "Codex Performance Benchmark"
  "Rating: $score/10"
  "Passed: $passed"
  "Failed: $failed"
  "Safe indexed files: $safeIndexed"
  "Knowledge routes: $knowledgeRoutes"
  ""
  foreach ($r in $results) {
    $mark = if ($r.passed) { "PASS" } else { "FAIL" }
    "{0} {1} - {2}" -f $mark, $r.id, $r.detail
  }
}

if ($failed -gt 0) { exit 1 }
