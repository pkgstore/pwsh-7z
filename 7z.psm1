function Compress-7z() {
  <#
    .SYNOPSIS
      Compress '7z' archive.
    .DESCRIPTION
  #>

  [CmdletBinding()]

  Param(
    [Parameter(
      Mandatory,
      HelpMessage="Enter file names..."
    )]
    [Alias("F")]
    [string[]]$P_Files
  )

  $7z = "$($PSScriptRoot)\7z.exe"

  ForEach ($File in (Get-ChildItem $($P_Files))) {
    & "$($7z)" a "$($File.Name + '.7z')" "$($File.FullName)"
  }
}

function Expand-7z() {
  <#
    .SYNOPSIS
      Expand '7z' archive.
    .DESCRIPTION
  #>

  [CmdletBinding()]

  Param(
    [Parameter(
      Mandatory,
      HelpMessage="Enter file names..."
    )]
    [Alias("F")]
    [string[]]$P_Files
  )

  $7z = "$($PSScriptRoot)\7z.exe"

  ForEach ($File in (Get-ChildItem "$($P_Files)")) {
    & "$($7z)" x "$($File.FullName)"
  }
}
