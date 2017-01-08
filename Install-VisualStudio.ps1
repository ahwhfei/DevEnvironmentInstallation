param([string]$VisualStudioIsoFile = "", [string]$OutputFolder = "C:\_VSInstall", [string]$Overwrite = $false)

if ($VisualStudioIsoFile -eq "") {
    $server = ""
    Write-Host "Please choice an installation server"
    do {
        $server = (Read-Host "(F)lorida/(N)anjing").ToLower()
    } until ($server -eq "f" -or $server -eq "n")

    if ($server -eq "f") {
        $VisualStudioIsoFile = "\\eng.citrite.net\ftl\Apps\Microsoft\VisualStudio\EN\2015\2015 with Update 3\Enterprise\vs2015.3.ent_enu.iso"
    } elseif ($server -eq "n") {
        $VisualStudioIsoFile = "\\njrdfs1.eng.citrite.net\CSP\Software\VisualStudio2015\en_visual_studio_enterprise_2015_with_update_3_x86_x64_dvd.iso"    
    }
}

function Warning {
    Write-Host -ForegroundColor Yellow "=============================================="
    Write-Host -ForegroundColor Yellow "Please make sure you have right to access $VisualStudioIsoFile!!!"
    Write-Host -ForegroundColor Yellow "=============================================="
    Write-Host -ForegroundColor Green "Prees any key to continue installation"
    [void][System.Console]::ReadKey($true)
}

Warning

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

function WaitAdminFile ($AdminFileName) {
    do {
	    Start-Sleep -Milliseconds 10
	} until (Test-Path -LiteralPath $AdminFileName)
}

function ExecuteVSInstallCommand ($CommandName) {
    $CommandFullPath = "$OutputFolder\$CommandName"
    if (Test-Path -LiteralPath ($CommandFullPath)) {
        Write-Host -ForegroundColor Green "Create Admin File..."
        iex ".\$CommandName /CreateAdminFile .\AdminDeployment.xml"

        WaitAdminFile $CommandFullPath

        Write-Host -ForegroundColor Green "Visual Studio Enterprise is installing slicently without user input"

        $AdminFile = "$OutputFolder\AdminDeployment.xml";
        $VSInstallCommand = ".\$CommandName" + ' /AdminFile "$AdminFile" /passive /norestart'
        iex $VSInstallCommand
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

