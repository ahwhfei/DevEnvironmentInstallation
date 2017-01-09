
# A PowerShell script to set up Windows machine for development
# NOTE: The script requires at least a version 4.0 .NET framework installed
# To run it inside a COMMAND PROMPT against the production branch (only one supported with self-elevation) use
# @powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/ahwhfei/DevEnvironmentInstallation/develop/Install.ps1'))"
# To run it inside a WINDOWS POWERSHELL console against the production branch (only one supported with self-elevation) use
# start-process -FilePath PowerShell.exe -Verb Runas -Wait -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command iex ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/ahwhfei/DevEnvironmentInstallation/develop/Install.ps1'))"

# Check if latest .NET framework installed is at least 4
$dotNetVersions = Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -recurse | Get-ItemProperty -name Version,Release -EA 0 | Where { $_.PSChildName -match '^(?!S)\p{L}'} | Select Version
$latestDotNetVersion = $dotNetVersions.GetEnumerator() | Sort-Object Version | Select-Object -Last 1
$latestDotNetMajorNumber = $latestDotNetVersion.Version.Split(".")[0]
if ($latestDotNetMajorNumber -lt 4) {
	Write-Host -ForegroundColor Red "To run this script, you need .NET 4.0 or later installed"
	if ((Read-Host "Do you want to open .NET Framework 4.6.1 download page (y/n)") -eq 'y') {
		Start-Process -FilePath "http://go.microsoft.com/fwlink/?LinkId=671729"
	}

	exit 1
}

$isAdministrator = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")
if (-not $isAdministrator) {
	Write-Host -ForegroundColor Red "Please Run CMD as Administrator!"
	
	exit 1
}

# Help with installing other dependencies
$script:answer = ""
function Install($programName, $message, $script, $shouldExit) {
	if ($script:answer -ne "a") {
		Write-Host -ForegroundColor Green "Allow the script to install $($programName)?"
		Write-Host "Tip: Note that if you type a you won't be prompted for subsequent installations"
		do {
			$script:answer = (Read-Host "(Y)es/(N)o/(A)ll").ToLower()
		} until ($script:answer -eq "y" -or $script:answer -eq "n" -or $script:answer -eq "a")

		if ($script:answer -eq "n") {
			Write-Host -ForegroundColor Yellow "You have chosen not to install $($programName). Some features may not work correctly if you haven't already installed it"
			return
		}
	}

	Write-Host $message
	Invoke-Expression($script)

	Write-Host "EXIT CODE: $LASTEXITCODE"
	if ($LASTEXITCODE -ne 0) {
		Write-Host -ForegroundColor Yellow "WARNING: $($programName) not installed"
	}
}

function Pause {
	Write-Host "Press any key to continue..."
	[void][System.Console]::ReadKey($true)
}

# Actually installing all other dependencies
# Install Chocolately
# Install "Chocolately(It's mandatory for the rest of the script)" "Installing Chocolately" "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))"

# if ((Get-Command "cinst" -ErrorAction SilentlyContinue) -eq $null) {
# 	Write-Host -ForegroundColor Red "Chocolatey is not installed or not configured properly. Download it from https://chocolatey.org/, install, set it up and run this script again."
# 	Pause
# 	exit 1
# }

# if ((Get-Command "webpicmd" -ErrorAction SilentlyContinue) -eq $null) {
# 	Write-Host -ForegroundColor Red "Web Platform Installer Command Line is not installed correctly, the following installation will depend on it. Now it will quit"
# 	Pause
# 	exit 1
# }

$ApplicationListObject = (new-object net.webclient).DownloadString('https://raw.githubusercontent.com/ahwhfei/DevEnvironmentInstallation/develop/Application-List.json') | ConvertFrom-Json

foreach ($app in $ApplicationListObject.Applications) {
	Install $app.Name $app.Message $app.Script
}

Write-Host -ForegroundColor Green "This script has modified your environment. You need to log off and log back on for the changes to take effect."
Pause
