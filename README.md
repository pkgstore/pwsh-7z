# PowerShell 7z Module

## Install

```powershell
${MOD} = "PkgStore.7z"; ${DIR} = "$( (${ENV:PSModulePath} -split ';')[0] )"; Invoke-WebRequest "https://github.com/pkgstore/pwsh-$( ${MOD}.ToLower() )/archive/refs/heads/main.zip" -OutFile "${DIR}\${MOD}.zip"; Expand-Archive -Path "${DIR}\${MOD}.zip" -DestinationPath "${DIR}"; Remove-Item -Path "${DIR}\${MOD}" -Recurse -Force; Rename-Item -Path "${DIR}\pwsh-${MOD}-main" -NewName "${DIR}\${MOD}"; Remove-Item -Path "${DIR}\${MOD}.zip";
```
