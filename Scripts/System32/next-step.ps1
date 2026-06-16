# ==============================================================================
# SCRIPT INJECT CONFIG (X:\Windows\System32\next-step.ps1)
# By Tran Trung Truc (tructransecure@gmail.com)
# ==============================================================================

Write-Host "[Monitor] OSDCloud da hoan tat. Bat dau quet kho cau hinh..." -ForegroundColor Green

# 1. Tim o dia USB chua thu muc SetupFiles
$USBPath = (Get-Volume | Where-Object { Test-Path "$($_.DriveLetter):\SetupFiles" } | Select-Object -First 1).DriveLetter

if (-not $USBPath) {
    Write-Host "[ERROR] Khong tim thay USB chua thu muc SetupFiles!" -ForegroundColor Red
    Start-Sleep -Seconds 5
    Exit
}
$SourcePath = "$($USBPath):\SetupFiles"

# 2. Dinh vi phan vung Windows tren o cung
$TargetDrive = (Get-Volume | Where-Object { Test-Path "$($_.DriveLetter):\Windows\System32" } | Select-Object -First 1).DriveLetter
if (-not $TargetDrive) {
    Write-Host "[ERROR] Khong tim thay o cai Windows!" -ForegroundColor Red
    Start-Sleep -Seconds 5
    Exit
}
$TargetOS = "$($TargetDrive):"

# 3. Copy file
try {
    $PantherPath = "$TargetOS\Windows\Panther"
    $CoreSystemPath = "$TargetOS\CoreSystem"
    if (-not (Test-Path $PantherPath)) { New-Item -ItemType Directory -Path $PantherPath -Force | Out-Null }
    if (-not (Test-Path $CoreSystemPath)) { New-Item -ItemType Directory -Path $CoreSystemPath -Force | Out-Null }

    if (Test-Path "$SourcePath\unattend.xml") { Copy-Item -Path "$SourcePath\unattend.xml" -Destination "$PantherPath\unattend.xml" -Force }
    if (Test-Path "$SourcePath\Post-setup.ps1") { Copy-Item -Path "$SourcePath\Post-setup.ps1" -Destination "$CoreSystemPath\Post-setup.ps1" -Force }
    
    Write-Host "[SUCCESS] Da inject file xong! Restart sau 5 giay..." -ForegroundColor Green
    Start-Sleep -Seconds 5
    wpeutil reboot
}
catch {
    Write-Host "[ERROR] Loi copy: $_" -ForegroundColor Red
    Start-Sleep -Seconds 10
}
