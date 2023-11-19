function Compress-7z() {
  <#
    .SYNOPSIS

    .DESCRIPTION
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
