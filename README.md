# PowerShell 7z Module

## Install

```powershell
${MOD} = "7z"; ${PFX} = "PkgStore"; ${DIR} = "$( (${ENV:PSModulePath} -split ';')[0] )"; Invoke-WebRequest "https://github.com/pkgstore/pwsh-$( ${MOD}.ToLower() )/archive/refs/heads/main.zip" -OutFile "${DIR}\${MOD}.zip"; Expand-Archive -Path "${DIR}\${MOD}.zip" -DestinationPath "${DIR}"; Remove-Item -Path "${DIR}\${PFX}.${MOD}" -Recurse -Force; Rename-Item -Path "${DIR}\pwsh-${MOD}-main" -NewName "${DIR}\${PFX}.${MOD}"; Remove-Item -Path "${DIR}\${MOD}.zip";
```
