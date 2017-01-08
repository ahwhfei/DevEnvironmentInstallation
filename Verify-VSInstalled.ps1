$result = (Get-Process | Where-Object { $_.ProcessName -eq "vs_enterprise" -or $_.ProcessName -eq "vs_professional" })

while (-not ([string]::IsNullOrWhiteSpace($result))) {
    Write-Host -NoNewline "."
    Start-Sleep -Seconds 10
}