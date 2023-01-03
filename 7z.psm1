function Compress-7z() {
  <#
    .SYNOPSIS
      Compress '7z' archive.
    .DESCRIPTION
      -F
        File list.
      -T
        Specifies type of archive ('7z' | 'BZIP2' | 'GZIP' | 'TAR' | 'WIM' | 'XZ' | 'ZIP').
        Default: '7z'.
      -MX
        Compression level (-mx1 (fastest) | ... | -mx9 (ultra)).
        Default: 5.
      -PWD | -P
        Password. Encrypt both file data and headers.
  #>

  [CmdletBinding()]

  Param(
    [Parameter(Mandatory, HelpMessage="File list.")]
    [Alias("F", "File", "Files")]
    [string[]]$P_File,

    [Parameter(HelpMessage="Specifies type of archive ('7z' | 'BZIP2' | 'GZIP' | 'TAR' | 'WIM' | 'XZ' | 'ZIP'). Default: '7z'.")]
    [ValidateSet("7z", "BZIP2", "GZIP", "TAR", "WIM", "XZ", "ZIP")]
    [Alias("T", "Type")]
    [string]$P_Type = "7z",

    [Parameter(HelpMessage="Compression level (-mx1 (fastest) | ... | -mx9 (ultra)). Default: 5.")]
    [ValidateRange(1,9)]
    [Alias("MX", "CompressionLevel", "Level")]
    [int]$P_MX = 5,

    [Parameter(HelpMessage="Password. Encrypt both file data and headers.")]
    [Alias("PWD", "P", "Password")]
    [string]$P_PWD
  )

  $7z = "$($PSScriptRoot)\7z.exe"

  if (-not (Test-Path -Path "$($7z)" -PathType "Leaf")) {
    Write-Error -Message "'7z.exe' not found!" -ErrorAction "Stop"
  }

  ForEach ($File in (Get-ChildItem $($P_File))) {
    $CMD = @("a", "-t$($P_Type)", "-mx$($P_MX)")
    if (-not ([string]::IsNullOrEmpty($P_PWD))) { $CMD += @("-p$($P_PWD)") }
    $CMD += @("$($File.Name + '.' + $P_Type.ToLower())", "$($File.FullName)")
    & "$($7z)" $CMD
  }
}

function Expand-7z() {
  <#
    .SYNOPSIS
      Expand '7z' archive.
    .DESCRIPTION
      -F
        File list.
  #>

  [CmdletBinding()]

  Param(
    [Parameter(Mandatory, HelpMessage="File list.")]
    [Alias("F", "File", "Files")]
    [string[]]$P_File
  )

  $7z = "$($PSScriptRoot)\7z.exe"

  if (-not (Test-Path -Path "$($7z)" -PathType "Leaf")) {
    Write-Error -Message "'7z.exe' not found!" -ErrorAction "Stop"
  }

  ForEach ($File in (Get-ChildItem "$($P_File)")) {
    $CMD = @("x", "$($File.FullName)", "-o$($File.Name)", "-aoa")
    & "$($7z)" $CMD
  }
}
