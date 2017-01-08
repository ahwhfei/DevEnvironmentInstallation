$result = ""
do {
    $result = (Get-Process | Where-Object { $_.ProcessName -eq "vs_enterprise" -or $_.ProcessName -eq "vs_professional" }) 
    Write-Host -NoNewline "."
    Start-Sleep -Seconds 10
} until ([string]::IsNullOrWhiteSpace($result))

Write-Host ""
if (($LASTEXITCODE -eq 0) -or ($LASTEXITCODE -eq 0x00000bc2)) {
    if ($LASTEXITCODE -eq 0x00000bc2) {
        Write-Host -ForegroundColor Green "Need to reboot to take effect."
    }
    Write-Host -ForegroundColor Green "Visual Studio Instatllation Comoplete"
} else {
    if (($LASTEXITCODE -eq 0x80044000) -or ($LASTEXITCODE -eq 0x8004C000)) {
        Write-Host "Block"
    }
    elseif (($LASTEXITCODE -eq 0x00000642) -or ($LASTEXITCODE -eq 0x80048642)) {
        Write-Host "Cancel"
    }
    elseif ($LASTEXITCODE -eq 0x80048bc7) {
        Write-Host "Incomplete-Reboot Required"
    }
    elseif (($LASTEXITCODE -eq 0x00000643) -or ($LASTEXITCODE -eq 0x80048643)) {
        Write-Host "Failure"
    }
    Write-Host -ForegroundColor Yellow "WARNING: Visual Studio may not installed"
}
