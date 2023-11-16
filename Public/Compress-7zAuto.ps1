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

  (Get-Item $P_In) | ForEach-Object {
    $I = "$($_.FullName)"         # Input data.
    $E = "$($P_Type.ToLower())"   # Output extension.

    $Param = @("a")                   # Creating archive.
    $Param += @("-t${P_Type}")        # Archive type.
    $Param += @("-mx${P_Level}")      # Compression level.
    $Param += @("$($I + '.' + $E)")   # Output archive.
    $Param += @("${I}")               # Input data.

    & $(Start-7Zip) $Param
  }
}
