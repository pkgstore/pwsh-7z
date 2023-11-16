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

  $I = "$((Get-Item $P_In).FullName)"   # Input data.
  $O = (($P_Out) ? $P_Out : $I)         # Output data.
  $E = "$($P_Type.ToLower())"           # Output extension.

  $Param = @("a")                   # Creating archive.
  $Param += @("-t${P_Type}")        # Archive type.
  $Param += @("-mx${P_Level}")      # Compression level.
  $Param += @("$($O + '.' + $E)")   # Output archive.
  $Param += @("${I}")               # Input data.

  & $(Start-7Zip) $Param
}
