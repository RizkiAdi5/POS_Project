# Sync changed POS files: Railo (dev) -> ColdFusion / IIS (inetpub)
# Usage:
#   .\deploy-to-cf.ps1              # copy default file list
#   .\deploy-to-cf.ps1 -AllWaiter   # all waiter/*.cfm
#   .\deploy-to-cf.ps1 -AllCustomer # all latest/customer/*.cfm

param(
    [string]$SourceRoot = "C:\railo\tomcat\webapps\ROOT",
    [string]$DestRoot   = "C:\inetpub\wwwroot\POS\POS_Project",
    [switch]$AllWaiter,
    [switch]$AllCustomer,
    [switch]$WhatIf
)

$ErrorActionPreference = "Stop"

$defaultFiles = @(
    "waiter\Orders.cfm",
    "waiter\Tables.cfm",
    "waiter\Menu.cfm",
    "waiter\MenuImage.cfm",
    "waiter\WaiterDashboard.cfm",
    "latest\Waiter\Orders.cfm",
    "latest\Waiter\Tables.cfm",
    "latest\Waiter\Menu.cfm",
    "latest\Waiter\MenuImage.cfm",
    "latest\Waiter\WaiterDashboard.cfm",
    "latest\customer\orderProcess.cfm",
    "latest\customer\my_orders.cfm",
    "latest\customer\open_order.cfm",
    "latest\customer\inc_emenu_order.cfm",
    "latest\customer\qr.cfm",
    "latest\customer\qr_error.cfm",
    "latest\customer\menu.cfm",
    "latest\customer\inc_bootstrap_head.cfm",
    "latest\customer\customer-bootstrap-overrides.css",
    "latest\customer\customer-emenu-fullbleed.css",
    "latest\js\vendor\qrcode.min.js",
    "latest\body\bodymenu.cfm",
    "application.cfm"
)

$filesToCopy = @($defaultFiles)

if ($AllWaiter) {
    $filesToCopy += @(Get-ChildItem -Path (Join-Path $SourceRoot "waiter") -Filter "*.cfm" -File -ErrorAction SilentlyContinue |
        ForEach-Object { "waiter\$($_.Name)" })
    $filesToCopy += @(Get-ChildItem -Path (Join-Path $SourceRoot "latest\Waiter") -Filter "*.cfm" -File -ErrorAction SilentlyContinue |
        ForEach-Object { "latest\Waiter\$($_.Name)" })
}

if ($AllCustomer) {
    $filesToCopy += @(Get-ChildItem -Path (Join-Path $SourceRoot "latest\customer") -Filter "*.cfm" -File -ErrorAction SilentlyContinue |
        ForEach-Object { "latest\customer\$($_.Name)" })
    $filesToCopy += @(Get-ChildItem -Path (Join-Path $SourceRoot "latest\customer") -Filter "*.css" -File -ErrorAction SilentlyContinue |
        ForEach-Object { "latest\customer\$($_.Name)" })
}

$unique = $filesToCopy | Select-Object -Unique

if (-not (Test-Path $SourceRoot)) {
    Write-Error "Source not found: $SourceRoot"
}
if (-not (Test-Path $DestRoot)) {
    Write-Error "Destination not found: $DestRoot`nCreate the folder or set -DestRoot to your CF web root."
}

Write-Host "Deploy: $SourceRoot"
Write-Host "    -> $DestRoot"
if ($WhatIf) { Write-Host "(WhatIf - no files will be written)" -ForegroundColor Yellow }
Write-Host ""

$copied = 0
$skipped = 0
$failed = 0

foreach ($rel in $unique) {
    $src = Join-Path $SourceRoot $rel
    $dst = Join-Path $DestRoot $rel

    if (-not (Test-Path $src)) {
        Write-Host "SKIP (missing source): $rel" -ForegroundColor DarkYellow
        $skipped++
        continue
    }

    $destDir = Split-Path $dst -Parent
    if (-not (Test-Path $destDir)) {
        if ($WhatIf) {
            Write-Host "Would create dir: $destDir"
        } else {
            New-Item -ItemType Directory -Path $destDir -Force | Out-Null
        }
    }

    try {
        if ($WhatIf) {
            Write-Host "Would copy: $rel"
        } else {
            Copy-Item -Path $src -Destination $dst -Force
            $srcTime = (Get-Item $src).LastWriteTime
            Write-Host "OK  $rel  ($srcTime)" -ForegroundColor Green
        }
        $copied++
    } catch {
        Write-Host "FAIL $rel - $($_.Exception.Message)" -ForegroundColor Red
        $failed++
    }
}

Write-Host ""
Write-Host "Done. Copied: $copied  Skipped: $skipped  Failed: $failed"

if (-not $WhatIf -and $copied -gt 0) {
    Write-Host ""
    Write-Host "Next steps for ColdFusion:" -ForegroundColor Cyan
    Write-Host "  1. CF Admin -> Caching -> Clear template cache"
    Write-Host "     OR restart 'ColdFusion 10 Application Server'"
    Write-Host "  2. Hard refresh browser (Ctrl+F5) on http://pos/..."
}
