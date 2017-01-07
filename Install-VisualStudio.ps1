param([string]$VisualStudioIsoFile = "", [string]$OutputFolder = "C:\_VSInstall", [string]$Overwrite = $true)

if (($VisualStudioIsoFile -eq "") -or ((Test-Path -LiteralPath $VisualStudioIsoFile) -eq $False)) {
    Write-Host -ForegroundColor Red "ERROR: $VisualStudioIsoFile file not found"
    Exit 1
}

if ((Test-Path $OutputFolder) -and $overwrite -eq $false) {
    Write-Host -ForegroundColor Yellow "WARNING: Skipping '$OutputFolder', reason: target path already exists"
    Exit 0
}

if (Test-Path $OutputFolder) {
    Write-Host -ForegroundColor Green "Delete exist folder, '$OutputFolder' deleting..."
    Remove-Item $OutputFolder -Recurse -Force
}

$mount_params = @{ImagePath = $VisualStudioIsoFile; PassThru = $true; ErrorAction = "Ignore"}
$mount = Mount-DiskImage @mount_params

if ($mount) {
    $volume = Get-DiskImage -ImagePath $mount.ImagePath | Get-Volume
    $source = $volume.DriveLetter + ":\*"
    $OutputFolder = mkdir $OutputFolder
    
    Write-Host -ForegroundColor Green "Extracting '$VisualStudioIsoFile' to '$OutputFolder'..."
    $params = @{Path = $source; Destination = $OutputFolder; Recurse = $true;}
    Copy-Item @params
    $hide = Dismount-DiskImage @mount_params
    Write-Host -ForegroundColor Green "Extract complete"
}
else {
    Write-Host -ForegroundColor Red "ERROR: Could not mount " $VisualStudioIsoFile " check if file is already in use"
}

$originFolder = $PWD
Set-Location $OutputFolder

function waitAdminFile ($AdminFileName) {
    do {
	    Start-Sleep -Milliseconds 10
	} until (Test-Path -LiteralPath $AdminFileName)
}

if (Test-Path -LiteralPath ($OutputFolder+"\vs_enterprise.exe")) {
    Write-Host -ForegroundColor Green "Create Admin File..."
    iex ".\vs_enterprise.exe /CreateAdminFile .\AdminDeployment.xml"

    waitAdminFile($OutputFolder+"\vs_enterprise.exe")

    Write-Host -ForegroundColor Green "Visual Studio Enterprise is installing in background, will compelete in 1-2 hours"
    iex ".\vs_enterprise.exe /AdminFile .\AdminDeployment.xml"
}
elseif (Test-Path -LiteralPath ($OutputFolder+"\vs_professional.exe")) {
    Write-Host -ForegroundColor Green "Create Admin File..."    
    iex ".\vs_professional.exe /CreateAdminFile .\AdminDeployment.xml"

    waitAdminFile($OutputFolder+"\vs_professional.exe")

    Write-Host -ForegroundColor Green "Visual Studio Professional is installing in background, will compelete in 1-2 hours"
    iex ".\vs_professional.exe /AdminFile .\AdminDeployment.xml /quiet /norestart"
} else {
    Write-Host -ForegroundColor Red "ERROR: not found vs installation file"
}

Set-Location $originFolder

