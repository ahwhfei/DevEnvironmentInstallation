param([string]$VisualStudioIsoFile = "", [string]$OutputFolder = "C:\_VSInstall", [string]$Overwrite = $false)

function Warning {
    Write-Host -ForegroundColor Yellow "=============================================="
    Write-Host -ForegroundColor Yellow "Please make sure you have right to access the path!!!"
    Write-Host -ForegroundColor Yellow $VisualStudioIsoFile
    Write-Host -ForegroundColor Yellow "=============================================="
    Write-Host "Tips: Note that check whether you have right to access the path. Copy link / Win+R / Login with your citrite account"
    do {
        $hasRight = (Read-Host "Has right? (Y)es/(N)o").ToLower()
    } until($hasRight -eq "y" -or $hasRight -eq "n")
    
    if ($hasRight -eq "n") {
        Write-Host -ForegroundColor Yellow "WARNING: Skipping visual studio installation"
        Exit 0
    }
    Write-Host -ForegroundColor Green "The next step will take long time..."
}

if ($VisualStudioIsoFile -eq "") {
    $server = ""
    Write-Host "Please choice an installation server"
    do {
        $server = (Read-Host "(F)lorida/(N)anjing").ToLower()
    } until ($server -eq "f" -or $server -eq "n")

    if ($server -eq "f") {
        $VisualStudioIsoFile = (new-object net.webclient).DownloadString('https://raw.githubusercontent.com/ahwhfei/DevEnvironmentInstallation/master/ftl.config')
    } elseif ($server -eq "n") {
        $VisualStudioIsoFile = (new-object net.webclient).DownloadString('https://raw.githubusercontent.com/ahwhfei/DevEnvironmentInstallation/master/nkg.config')
    }

    Warning
}

if (($VisualStudioIsoFile -eq "") -or ((Test-Path -LiteralPath $VisualStudioIsoFile) -eq $False)) {
    Write-Host -ForegroundColor Red "ERROR: $VisualStudioIsoFile file not found"
    Exit 1
}

if ((Test-Path $OutputFolder) -and ($Overwrite -eq $true)) {
    Write-Host -ForegroundColor Green "Delete exist folder, '$OutputFolder' deleting..."
    Remove-Item $OutputFolder -Recurse -Force
}

if (-not (Test-Path $OutputFolder)) {
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
        Exit 1
    }
}

if (-not (Test-Path $OutputFolder)) {
    Write-Host -ForegroundColor Red "ERROR: Visual Studio Exacting Failed"
    Exit 1
}

$originFolder = $PWD
Set-Location $OutputFolder

function ExecuteVSInstallCommand ($CommandName) {
    $CommandFullPath = "$OutputFolder\$CommandName"
    if (Test-Path -LiteralPath ($CommandFullPath)) {
        $AdminFile = "$OutputFolder\AdminDeployment.xml"
        Write-Host -ForegroundColor Green "Create Admin File..."
        Start-Process -FilePath "$CommandFullPath" -ArgumentList "/CreateAdminFile $AdminFile /quiet" -Wait

        Write-Host -ForegroundColor Green "Visual Studio Enterprise is installing slicently without user input"
        Write-Host -ForegroundColor Green "Please wait ..."
        Start-Process -FilePath "$CommandFullPath" -ArgumentList '/AdminFile "$AdminFile" /quiet /norestart' -Wait
    }
}

if (Test-Path -LiteralPath ("$OutputFolder\vs_enterprise.exe")) {
    ExecuteVSInstallCommand "vs_enterprise.exe"
}
elseif (Test-Path -LiteralPath ("$OutputFolder\vs_professional.exe")) {
    ExecuteVSInstallCommand "vs_professional.exe"
} else {
    Write-Host -ForegroundColor Red "ERROR: not found vs installation file"
}

Set-Location $originFolder

