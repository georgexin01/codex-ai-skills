$targetDirs = @(
    "c:\Users\user\.codex\sessions",
    "c:\Users\user\.codex\ambient-suggestions",
    "c:\Users\user\.codex\.tmp"
)

$daysThreshold = 2
$limitDate = (Get-Date).AddDays(-$daysThreshold)

Write-Host "Starting Bi-Daily System Hygiene Protocol..."
Write-Host "Threshold Date: $limitDate"

$deletedFiles = 0

foreach ($dir in $targetDirs) {
    if (Test-Path $dir) {
        Write-Host "Scanning $dir..."
        # Delete old files
        $files = Get-ChildItem -Path $dir -Recurse -File | Where-Object { $_.LastWriteTime -lt $limitDate }
        foreach ($file in $files) {
            Remove-Item -Path $file.FullName -Force -ErrorAction SilentlyContinue
            $deletedFiles++
        }
        
        # Cleanup empty directories left behind
        Get-ChildItem -Path $dir -Recurse -Directory | Where-Object { (Get-ChildItem -Path $_.FullName -Recurse -File).Count -eq 0 } | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    }
}

Write-Host "Cleanup Complete. Total legacy files deleted: $deletedFiles"
