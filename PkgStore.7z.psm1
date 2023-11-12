<#PSScriptInfo
  .VERSION      0.1.0
  .GUID         613eb0b0-1b1e-4f28-92c9-1c6e73e91a1a
  .AUTHOR       Kitsune Solar
  .AUTHOREMAIL  mail@kitsune.solar
  .COMPANYNAME  iHub.TO
  .COPYRIGHT    2023 Kitsune Solar. All rights reserved.
  .LICENSEURI   https://github.com/pkgstore/pwsh-7z/blob/main/LICENSE
  .PROJECTURI   https://github.com/pkgstore/pwsh-7z
#>

$App = @('7za.exe', '7za.dll', '7zxa.dll')
$AppExe = @{LiteralPath = "${PSScriptRoot}"; Filter = "$($App[0])"; Recurse = $true; File = $true}
$AppExe = ((Get-ChildItem @AppExe) | Select-Object -First 1)
$NL = "$([Environment]::NewLine)"

function Compress-7z() {
  <#
    .SYNOPSIS

    .DESCRIPTION
  #>

  Param(
    [Parameter(Mandatory)][Alias('I')][string[]]$P_In,
    [Parameter(Mandatory)][Alias('O')][string[]]$P_Out,
    [ValidateSet('7z', 'BZIP2', 'GZIP', 'TAR', 'WIM', 'XZ', 'ZIP')][Alias('T')][string]$P_Type = '7z',
    [ValidateRange(1,9)][Alias('L')][int]$P_Level = 5,
    [Alias('P')][string]$P_Password,
    [Alias('D')][switch]$P_Delete = $false
  )

  Test-App

  (Get-ChildItem $P_In) | ForEach-Object {
    $Param = @("a", "-t${P_Type}", "-mx${P_Level}")
    if (-not ([string]::IsNullOrEmpty($P_Password))) { $Param += @("-p${P_Password}") }
    if ($P_Delete) { $Param += @("-sdel") }
    if ($P_Out) {
      $Param += @("${P_Out}")
    } else {
      $Param += @("$($_.FullName + '.' + $P_Type.ToLower())", "$($_.FullName)")
    }

    & "${AppExe}" $Param
  }
}

function Expand-7z() {
  <#
    .SYNOPSIS

    .DESCRIPTION
  #>

  Param(
    [Parameter(Mandatory)][Alias('I')][string[]]$P_In
  )

  Test-App

  (Get-ChildItem $P_In) | ForEach-Object {
    $Param = @('x', "$($_.FullName)")

    & "${AppExe}" $Param
  }
}

function Compress-ISO() {
  <#
    .SYNOPSIS

    .DESCRIPTION
  #>

  Param(
    [Parameter(Mandatory)][Alias('I')][string[]]$P_In
  )

  Test-App

  (Get-ChildItem $P_In) | ForEach-Object {
    # Hash 'SHA1' pattern.
    $SHA1 = Get-FileHash "$($_.FullName)" -Algorithm 'SHA1'
      | Select-Object 'Hash', @{N = 'Path'; E = {$_.Path | Resolve-Path -Relative}}
    $SHA1 | Out-File "$($_.FullName + '.sha1')"

    # Hash 'SHA256' pattern.
    $SHA256 = Get-FileHash "$($_.FullName)" -Algorithm 'SHA256'
      | Select-Object 'Hash', @{N = 'Path'; E = {$_.Path | Resolve-Path -Relative}}
    $SHA256 | Out-File "$($_.FullName + '.sha256')"

    # Compressing a '*.ISO' file.
    Compress-7z -I "$($_.FullName)" -L 9
  }
}

function Test-App {
  <#
    .SYNOPSIS

    .DESCRIPTION
  #>

  # Getting '7za.exe' directory.
  $Dir = "$($AppExe.DirectoryName)"

  # Checking the location of files.
  $App | ForEach-Object {
    if (-not (Test-Data -T 'F' -P "${Dir}\${_}")) {
      Write-Msg -T 'W' -A 'Stop' -M ("'${_}' not found!${NL}${NL}" +
      "1. Download '${_}' from 'https://www.7-zip.org/download.html'.${NL}" +
      "2. Extract all the contents of the archive into a directory '${PSScriptRoot}'.")
    }
  }
}
