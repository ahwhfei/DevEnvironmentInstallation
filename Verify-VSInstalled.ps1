$result = ""
do {
    $result = (Get-Process | Where-Object { $_.ProcessName -eq "vs_enterprise" -or $_.ProcessName -eq "vs_professional" }) 
    Write-Host -NoNewline "."
    Start-Sleep -Seconds 10
} until ([string]::IsNullOrWhiteSpace($result))

Write-Host ""
if ($LASTEXITCODE -eq 0) {
    Write-Host -ForegroundColor Green "Visual Studio Instatllation Comoplete"
} else {
    Write-Host -ForegroundColor Yellow "WARNING: Visual Studio may not installed"
}

