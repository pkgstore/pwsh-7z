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
    [Parameter(Mandatory)][Alias('I')][string]$P_In,
    [Alias('O')][string]$P_Out,
    [ValidateSet('7z', 'zip')][Alias('T')][string]$P_Type = '7z',
    [ValidateRange(1,9)][Alias('L')][int]$P_Level = 5
  )

  # Checking 7-Zip location.
  Test-7Zip

  $I = "$((Get-Item $P_In).FullName)"   # Input data.
  $O = (($P_Out) ? $P_Out : $I)         # Output data.
  $E = "$($P_Type.ToLower())"           # Output extension.

  $Param = @("a")                   # Creating archive.
  $Param += @("-t${P_Type}")        # Archive type.
  $Param += @("-mx${P_Level}")      # Compression level.
  $Param += @("$($O + '.' + $E)")   # Output archive.
  $Param += @("${I}")               # Input data.

  & "${AppExe}" $Param
}

function Compress-7zAuto() {
  <#
    .SYNOPSIS

    .DESCRIPTION
  #>

  Param(
    [Parameter(Mandatory)][Alias('I')][string[]]$P_In,
    [ValidateSet('7z', 'zip')][Alias('T')][string]$P_Type = '7z',
    [ValidateRange(1,9)][Alias('L')][int]$P_Level = 5
  )

  # Checking 7-Zip location.
  Test-7Zip

  (Get-Item $P_In) | ForEach-Object {
    $I = "$($_.FullName)"         # Input data.
    $E = "$($P_Type.ToLower())"   # Output extension.

    $Param = @("a")                   # Creating archive.
    $Param += @("-t${P_Type}")        # Archive type.
    $Param += @("-mx${P_Level}")      # Compression level.
    $Param += @("$($I + '.' + $E)")   # Output archive.
    $Param += @("${I}")               # Input data.

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

  # Checking 7-Zip location.
  Test-7Zip

  (Get-Item $P_In) | ForEach-Object {
    $I = "$($_.FullName)"   # Input data.
    $Param = @('x')         # Extract archive.
    $Param += @("${I}")     # Input data.

    & "${AppExe}" $Param
  }
}

function Compress-ISO() {
  <#
    .SYNOPSIS

    .DESCRIPTION
  #>

  Param(
    [Parameter(Mandatory)][Alias('I')][string]$P_In
  )

  # Checking 7-Zip location.
  Test-7Zip

  (Get-Item $P_In) | ForEach-Object {
    $I = "$($_.FullName)"
    # Hash 'SHA1' pattern.
    $SHA1 = Get-FileHash "${I}" -Algorithm 'SHA1'
      | Select-Object 'Hash', @{N = 'Path'; E = {$_.Path | Resolve-Path -Relative}}
    $SHA1 | Out-File "$($I + '.sha1')"

    # Hash 'SHA256' pattern.
    $SHA256 = Get-FileHash "${I}" -Algorithm 'SHA256'
      | Select-Object 'Hash', @{N = 'Path'; E = {$_.Path | Resolve-Path -Relative}}
    $SHA256 | Out-File "$($I + '.sha256')"

    # Compressing a '*.ISO' file.
    Compress-7z -I "${I}" -L 9
  }
}

function Test-7Zip {
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
