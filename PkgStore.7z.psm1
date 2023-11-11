<#PSScriptInfo
  .VERSION      0.1.0
  .GUID         613eb0b0-1b1e-4f28-92c9-1c6e73e91a1a
  .AUTHOR       Kitsune Solar
  .AUTHOREMAIL  mail@kitsune.solar
  .COMPANYNAME  iHub.TO
  .COPYRIGHT    2023 Kitsune Solar. All rights reserved.
  .LICENSEURI   https://choosealicense.com/licenses/mit/
  .PROJECTURI
#>

$7Za = @('7za.exe', '7za.dll', '7zxa.dll')
$7ZaExe = ((Get-ChildItem -LiteralPath "${PSScriptRoot}" -Filter "$($7Za[0])" -Recurse -File) | Select-Object -First 1)
$NL = "$([Environment]::NewLine)"

function Compress-7z() {
  <#
    .SYNOPSIS

    .DESCRIPTION
  #>

  Param(
    [Alias('A')][string]$P_App = $7ZaExe,
    [Parameter(Mandatory)][SupportsWildcards()][Alias('F')][string[]]$P_Files,
    [ValidateSet('7z', 'BZIP2', 'GZIP', 'TAR', 'WIM', 'XZ', 'ZIP')][Alias('T')][string]$P_Type = '7z',
    [ValidateRange(1,9)][Alias('L')][int]$P_Level = 5,
    [Alias('P')][string]$P_Password,
    [Alias('D')][switch]$P_Delete = $false
  )

  Test-7Zip

  (Get-ChildItem $P_Files) | ForEach-Object {
    $Params = @("a", "-t${P_Type}", "-mx${P_Level}")
    if (-not ([string]::IsNullOrEmpty($P_Password))) { $Params += @("-p${P_Password}") }
    if ($P_Delete) { $Params += @("-sdel") }
    $Params += @("$($_.FullName + '.' + $P_Type.ToLower())", "$($_.FullName)")

    & "${P_App}" $Params
  }
}

function Expand-7z() {
  <#
    .SYNOPSIS

    .DESCRIPTION
  #>

  Param(
    [Alias('A')][string]$P_App = $7ZaExe,
    [Parameter(Mandatory)][SupportsWildcards()][Alias('F')][string[]]$P_Files
  )

  Test-7Zip

  (Get-ChildItem $P_Files) | ForEach-Object {
    $Params = @('x', "$($_.FullName)")

    & "${P_App}" $Params
  }
}

function Compress-ISO() {
  <#
    .SYNOPSIS

    .DESCRIPTION
  #>

  Param(
    [Parameter(Mandatory)][SupportsWildcards()][Alias('F')][string[]]$P_Files
  )

  Test-7Zip

  (Get-ChildItem $P_Files) | ForEach-Object {
    # Hash 'SHA1' pattern.
    $SHA1 = Get-FileHash "$($_.FullName)" -Algorithm 'SHA1'
      | Select-Object 'Hash', @{N = 'Path'; E = {$_.Path | Resolve-Path -Relative}}
    $SHA1 | Out-File "$($_.FullName + '.sha1')"

    # Hash 'SHA256' pattern.
    $SHA256 = Get-FileHash "$($_.FullName)" -Algorithm 'SHA256'
      | Select-Object 'Hash', @{N = 'Path'; E = {$_.Path | Resolve-Path -Relative}}
    $SHA256 | Out-File "$($_.FullName + '.sha256')"

    # Compressing a '*.ISO' file.
    Compress-7z -F "$($_.FullName)" -L 9
  }
}

function Test-7Zip {
  # Getting '7za.exe' directory.
  $D_App = "$($7ZaExe.DirectoryName)"

  # Checking the location of files.
  $7Za | ForEach-Object {
    if (-not (Test-Data -T 'F' -P "${D_App}\${_}")) {
      Write-Msg -T 'W' -A 'Stop' -M ("'${_}' not found!${NL}${NL}" +
      "1. Download 7-Zip Extra from 'https://www.7-zip.org/download.html'.${NL}" +
      "2. Extract all the contents of the archive into a directory '${PSScriptRoot}'.")
    }
  }
}
