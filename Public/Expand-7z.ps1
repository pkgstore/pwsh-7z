function Expand-7z() {
  <#
    .SYNOPSIS
    Unpacking compressed files.

    .DESCRIPTION
    Unpacking compressed files using 7-Zip.

    .PARAMETER In
    Input data.

    .EXAMPLE
    Expand-7z -In '*.7z'
  #>

  param(
    [Parameter(Mandatory)][Alias('I')][string[]]$In
  )

  (Get-Item $In) | ForEach-Object {
    $I = "$($_.FullName)"   # Input data.
    $Param = @('x')         # Extract archive.
    $Param += @("${I}")     # Input data.

    & $(Start-7Zip) $Param
  }
}
