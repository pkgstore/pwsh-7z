function Compress-7z() {
  <#
    .SYNOPSIS
      Compress '7z' archive.
    .DESCRIPTION
  #>

  [CmdletBinding()]

  Param(
    [Parameter(Mandatory, HelpMessage="File list.")]
    [Alias("F", "Files", "File")]
    [string[]]$P_File,

    [Parameter(HelpMessage="Specifies type of archive. It can be: '7z', 'BZIP2', 'GZIP', 'TAR', 'WIM', 'XZ', 'ZIP'.")]
    [ValidateSet("7z", "BZIP2", "GZIP", "TAR", "WIM", "XZ", "ZIP")]
    [Alias("T", "Type")]
    [string]$P_Type = "7z",

    [Parameter(HelpMessage="Compression level (-mx1 (fastest) / ... / -mx9 (ultra)).")]
    [ValidateRange(1,9)]
    [Alias("MX", "CompressionLevel", "Level")]
    [int]$P_MX = 5,

    [Parameter(HelpMessage="Password.")]
    [Alias("P", "Password")]
    [string]$P_PWD = ""
  )

  $7z = "$($PSScriptRoot)\7z.exe"

  if (-not (Test-Path -Path "$($7z)" -PathType "Leaf")) {
    Write-Error -Message "'7z.exe' not found!" -ErrorAction "Stop"
  }

  if (-not ([string]::IsNullOrEmpty($P_PWD))) { $P_PWD = "-p$($P_PWD) -mhe" }

  ForEach ($File in (Get-ChildItem $($P_File))) {
    & "$($7z)" -t$($P_Type) -mx$($P_MX) $($P_PWD) a "$($File.Name + '.7z')" "$($File.FullName)"
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
    [Parameter(Mandatory, HelpMessage="File list.")]
    [Alias("F", "Files", "File")]
    [string[]]$P_File
  )

  $7z = "$($PSScriptRoot)\7z.exe"

  if (-not (Test-Path -Path "$($7z)" -PathType "Leaf")) {
    Write-Error -Message "'7z.exe' not found!" -ErrorAction "Stop"
  }

  ForEach ($File in (Get-ChildItem "$($P_File)")) {
    & "$($7z)" x "$($File.FullName)"
  }
}
