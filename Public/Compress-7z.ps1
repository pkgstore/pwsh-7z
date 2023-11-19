function Compress-7z() {
  <#
    .SYNOPSIS
    Data compression.

    .DESCRIPTION
    Data compression using 7-Zip.

    .PARAMETER In
    Input data.

    .PARAMETER Out
    Output data.

    .PARAMETER Type
    Compression type.

    .PARAMETER Level
    Compression level.

    .EXAMPLE
    Compress-7z -In 'File.TXT'

    .EXAMPLE
    Compress-7z -In 'File.TXT' -Out 'D:\Docs\File'

    .EXAMPLE
    Compress-7z -In 'File.TXT' -Out 'D:\Docs\File' -Type 'zip' -Level 3
  #>

  param(
    [Parameter(Mandatory)][Alias('I')][string]$In,
    [Alias('O')][string]$Out,
    [ValidateSet('7z', 'zip')][Alias('T')][string]$Type = '7z',
    [ValidateRange(1,9)][Alias('L')][int]$Level = 5
  )

  $I = "$((Get-Item $In).FullName)"   # Input data.
  $O = (($Out) ? $Out : $I)           # Output data.
  $E = "$($Type.ToLower())"           # Output extension.

  $Param = @("a")                   # Creating archive.
  $Param += @("-t${Type}")          # Archive type.
  $Param += @("-mx${Level}")        # Compression level.
  $Param += @("$($O + '.' + $E)")   # Output archive.
  $Param += @("${I}")               # Input data.

  & $(Start-7Zip) $Param
}
