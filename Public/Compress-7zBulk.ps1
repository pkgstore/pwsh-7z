function Compress-7zBulk() {
  <#
    .SYNOPSIS
    Bulk data compression.

    .DESCRIPTION
    Bulk data compression using 7-Zip.

    .PARAMETER In
    Bulk input data.

    .PARAMETER Type
    Compression type.

    .PARAMETER Level
    Compression level.

    .EXAMPLE
    Compress-7z -In '*.TXT'

    .EXAMPLE
    Compress-7z -In '*.TXT' -Type 'zip' -Level 3
  #>

  param(
    [Parameter(Mandatory)][Alias('I')][string[]]$In,
    [ValidateSet('7z', 'zip')][Alias('T')][string]$Type = '7z',
    [ValidateRange(1,9)][Alias('L')][int]$Level = 5
  )

  (Get-Item $In) | ForEach-Object {
    $I = "$($_.FullName)"       # Input data.
    $E = "$($Type.ToLower())"   # Output extension.

    $Param = @("a")                   # Creating archive.
    $Param += @("-t${Type}")          # Archive type.
    $Param += @("-mx${Level}")        # Compression level.
    $Param += @("$($I + '.' + $E)")   # Output archive.
    $Param += @("${I}")               # Input data.

    & $(Start-7Zip) $Param
  }
}
