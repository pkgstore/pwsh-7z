# PowerShell 7z Module

## Install

```powershell
${MOD} = "7z"; ${DIR} = "$( (${ENV:PSModulePath} -split ';')[0] )"; Invoke-WebRequest "https://github.com/pkgstore/pwsh-$( ${MOD}.ToLower() )/archive/refs/heads/main.zip" -OutFile "${DIR}\${MOD}.zip"; Expand-Archive -Path "${DIR}\${MOD}.zip" -DestinationPath "${DIR}"; Rename-Item -Path "${DIR}\pwsh-${MOD}-main" -NewName "${DIR}\PkgStore.${MOD}"; Remove-Item -Path "${DIR}\${MOD}.zip";
```
