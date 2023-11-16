function Expand-7z() {
  <#
    .SYNOPSIS

    .DESCRIPTION
  #>

  Param(
    [Parameter(Mandatory)][Alias('I')][string[]]$P_In
  )

  (Get-Item $P_In) | ForEach-Object {
    $I = "$($_.FullName)"   # Input data.
    $Param = @('x')         # Extract archive.
    $Param += @("${I}")     # Input data.

    & $(Start-7Zip) $Param
  }
}
