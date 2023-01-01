<#
  .SYNOPSIS
  .DESCRIPTION
#>

Param(
  [Parameter(
    Mandatory,
    HelpMessage="Enter file names..."
  )]
  [Alias("F")]
  [string[]]$P_Files
)

function Compress-7z() {
  ForEach ($File in (Get-ChildItem $($P_Files))) {
    & "$($ENV:ProgramFiles)\7-Zip\7z.exe" a "$($File.Name + '.7z')" "$($File.FullName)"
  }
}

function Expand-7z() {
  ForEach ($File in (Get-ChildItem "$($P_Files)")) {
    & "$($ENV:ProgramFiles)\7-Zip\7z.exe" x "$($File.FullName)"
  }
}
