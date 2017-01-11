import { Application } from './application'

export const APPLICATIONS: Application[] = [
    {
        "id": 1,
        "name": "Chocolately",
        "version": "",
        "message": "Installing Chocolately",
        "script": "iex (new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')",
        "quitCode": 0,
        "dependency": []
    },
    {
        "id": 2,
        "name": "Web Platform Installer Command Line",
        "version": "",
        "message": "Installing Web Platform Installer Command Line",
        "script": "cinst webpicmd --force --yes",
        "quitCode": 0,
        "dependency": [{"id": 1}]
    },
    {
        "id": 3,
        "name": "Node JS",
        "version": "",
        "message": "Installing Node JS",
        "script": "cinst nodejs.install --force --yes",
        "quitCode": 0,
        "dependency": [{"id": 1}]
    },
    {
        "id": 4,
        "name": "Visual Studio",
        "version": "",
        "message": "Installing Visual Studio",
        "script": "iex (new-object net.webclient).DownloadString('https://raw.githubusercontent.com/ahwhfei/DevEnvironmentInstallation/develop/plugins/visualstudio/Install-VisualStudio.ps1')",
        "dependency": [{"id": 1}]
    },
    {
        "id": 5,
        "name": "Google Chrome",
        "version": "",
        "message": "Installing Google Chrome",
        "script": "cinst googlechrome --force --yes",
        "quitCode": 0,
        "dependency": [{"id": 1}]
    },
    {
        "id": 6,
        "name": "Sublime Text3",
        "version": "",
        "message": "Installing Sublime Text3",
        "script": "cinst sublimetext3 --force --yes",
        "quitCode": 0,
        "dependency": [{"id": 1}]
    },
    {
        "id": 7,
        "name": "Visual Studio Code",
        "version": "",
        "message": "Installing Visual Studio Code",
        "script": "cinst visualstudiocode --force --yes",
        "quitCode": 0,
        "dependency": [{"id": 1}]
    },
    
    {
        "id": 8,
        "name": "Source Tree",
        "version": "",
        "message": "Installing Source Tree",
        "script": "cinst sourcetree --force --yes",
        "quitCode": 0,
        "dependency": [{"id": 1}]
    },
    {
        "id": 9,
        "name": "Git",
        "version": "",
        "message": "Installing Git",
        "script": "cinst git --force --yes",
        "quitCode": 0,
        "dependency": [{"id": 1}]
    },
    {
        "id": 10,
        "name": "ReSharper",
        "version": "",
        "message": "Installing ReSharper",
        "script": "cinst resharper --force --yes",
        "quitCode": 0,
        "dependency": [{"id": 1}]
    },
    {
        "id": 11,
        "name": "JRE",
        "version": "",
        "message": "Installing Java Runtime Environment",
        "script": "cinst jre8 --force --yes",
        "quitCode": 0,
        "dependency": [{"id": 1}]
    },
    {
        "id": 12,
        "name": "Wix Toolset",
        "version": "",
        "message": "Installing Wix Toolset",
        "script": "cinst wixtoolset --force --yes --allow-empty-checksums",
        "quitCode": 0,
        "dependency": [{"id": 1}]
    },
    
    {
        "id": 13,
        "name": "Azure PowerShell",
        "version": "",
        "message": "Installing Azure PowerShell",
        "script": "webpicmd /install /products:'Microsoft Azure PowerShell' /AcceptEULA /SuppressReboot",
        "dependency": [{"id": 2}]
    },
    {
        "id": 14,
        "name": "Azure SDK for .net (VS2015) - 2.9.6",
        "version": "",
        "message": "Installing Azure SDK",
        "script": "webpicmd /install /products:'Microsoft Azure SDK for .NET (VS 2015) - 2.9.6'",
        "dependency": [{"id": 2}]
    },
    {
        "id": 15,
        "name": "Azure Service Fabric SDK",
        "version": "",
        "message": "Installing Azure Service Fabric SDK",
        "script": "webpicmd /install /products:'Microsoft Azure Service Fabric SDK and Tools - 2.4.145 (VS2015)' /AcceptEULA /SuppressReboot",
        "dependency": [{"id": 2}]
    },
    {
        "id": 16,
        "name": "Aws SDK",
        "version": "",
        "message": "Installing Aws SDK",
        "script": "Start-Process -FilePath msiexec.exe -ArgumentList '/i https://sdk-for-net.amazonwebservices.com/latest/AWSToolsAndSDKForNet.msi /quiet /norestart' -wait",
        "dependency": []
    }
]