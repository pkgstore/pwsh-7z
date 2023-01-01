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

  ForEach ($File in (Get-ChildItem $($P_Files))) {
    & "$($ENV:ProgramFiles)\7-Zip\7z.exe" a "$($File.Name + '.7z')" "$($File.FullName)"
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

  ForEach ($File in (Get-ChildItem "$($P_Files)")) {
    & "$($ENV:ProgramFiles)\7-Zip\7z.exe" x "$($File.FullName)"
  }
}
