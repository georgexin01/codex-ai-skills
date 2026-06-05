param(
  [int]$IntervalSeconds = 120
)

$ErrorActionPreference = "Continue"
$scriptPath = "C:\Users\user\.codex\codex-router\Update-CodexRouting.ps1"

while ($true) {
  try {
    & $scriptPath -Quiet
  } catch {}
  Start-Sleep -Seconds $IntervalSeconds
}
