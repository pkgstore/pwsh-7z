# PowerShell 7-ZIP Module

PowerShell module for working with 7-ZIP.

## Install

```powershell
${MOD} = "7z"; ${PFX} = "PkgStore"; ${DIR} = "$( (${env:PSModulePath} -split ';')[0] )"; Invoke-WebRequest "https://github.com/pkgstore/pwsh-${MOD}/archive/refs/heads/main.zip" -OutFile "${DIR}\${MOD}.zip"; Expand-Archive -Path "${DIR}\${MOD}.zip" -DestinationPath "${DIR}"; if ( Test-Path -Path "${DIR}\${PFX}.${MOD}" ) { Remove-Item -Path "${DIR}\${PFX}.${MOD}" -Recurse -Force }; Rename-Item -Path "${DIR}\pwsh-${MOD}-main" -NewName "${DIR}\${PFX}.${MOD}"; Remove-Item -Path "${DIR}\${MOD}.zip";
```

## Syntax

For syntax information, enter module info command and get help command.

```powershell
Get-Command -Module 'PkgStore.7z'
```

```powershell
Get-Help '<COMMAND-NAME>'
```
