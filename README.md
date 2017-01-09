## Tool Name
Windows Development Environment Installation Automation Tool
## Motivation
The goal of this script is for installing dev machine automated. It's benefit for new employee, or setup a dev VM quickly.
## How to Use
* Open "cmd" to run the command as administrator
```PowerShell
@powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/ahwhfei/DevEnvironmentInstallation/master/DevEnvironmentInstallation.ps1'))"
```
## Applications List
* These applications will be installed automatically:
* Google Chrome
* Sublime text 3
* Visual Studio Code
* NodeJS
* Bower
* Grunt
* Source Tree
* Git
* Resharper
* JRE
* Visual Studio 2015 Enterprise with Update 3
* Azure SDK
* Azure Service Fabric SDK
* Azure PowerShell
* Wix Toolset
