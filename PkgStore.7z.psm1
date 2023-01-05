function Compress-7z() {
  <#
    .SYNOPSIS
      Compress '7z' archive.
    .DESCRIPTION
      -F
        File list.
      -T
        Specifies type of archive.
        Value: ['7z' | 'BZIP2' | 'GZIP' | 'TAR' | 'WIM' | 'XZ' | 'ZIP'].
        Default: '7z'.
      -L
        Compression level.
        Value: [1 | ... | 9].
        Default: 5.
      -P | -PWD
        Password. Encrypt both file data and headers.
      -D | -DEL
        Delete files after compression.
  #>

  [CmdletBinding()]

  Param(
    [Parameter(Mandatory, HelpMessage="File list.")]
    [SupportsWildcards()]
    [Alias('File', 'F')]
    [string[]]${Files},

    [Parameter(HelpMessage="Specifies type of archive. Value: ['7z' | 'BZIP2' | 'GZIP' | 'TAR' | 'WIM' | 'XZ' | 'ZIP']. Default: '7z'.")]
    [ValidateSet('7z', 'BZIP2', 'GZIP', 'TAR', 'WIM', 'XZ', 'ZIP')]
    [Alias('T')]
    [string]${Type} = '7z',

    [Parameter(HelpMessage="Compression level. Value: [1 | ... | 9]. Default: 5.")]
    [ValidateRange(1,9)]
    [Alias('LVL', 'L')]
    [int]${Level} = 5,

    [Parameter(HelpMessage="Password. Encrypt both file data and headers.")]
    [Alias('PWD', 'P')]
    [string]${Password},

    [Parameter(HelpMessage="Delete files after compression.")]
    [Alias('DEL', 'D')]
    [switch]${Delete} = $false
  )

  $7z = "${PSScriptRoot}\7z.exe"

  if (-not (Test-Path -Path "${7z}" -PathType "Leaf")) {
    Write-Error -Message "'7z.exe' not found!" -ErrorAction "Stop"
  }

  ForEach ( ${File} in ( Get-ChildItem ${Files} ) ) {
    ${FullName} = "$( ${File}.FullName )"
    ${CMD} = @( "a", "-t${Type}", "-mx${Level}" )
    if ( -not ( [string]::IsNullOrEmpty(${Password}) ) ) { ${CMD} += @( "-p${Password}" ) }
    if ( ${Delete} ) { ${CMD} += @( "-sdel" ) }
    ${CMD} += @( "$( ${FullName} + '.' + ${Type}.ToLower() )", "${FullName}" )

    & "${7z}" ${CMD}
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
    [SupportsWildcards()]
    [Alias('File', 'F')]
    [string[]]${Files}
  )

  $7z = "${PSScriptRoot}\7z.exe"

  if ( -not ( Test-Path -Path "${7z}" -PathType "Leaf" ) ) {
    Write-Error -Message "'7z.exe' not found!" -ErrorAction "Stop"
  }

  ForEach ( ${File} in ( Get-ChildItem "${Files}" ) ) {
    ${FullName} = "$( ${File}.FullName )"
    ${CMD} = @( "x", "${FullName}" )

    & "${7z}" ${CMD}
  }
}

function Compress-ISO() {
  <#
    .SYNOPSIS
      Compress 'ISO' to archive.
    .DESCRIPTION
      -F
        File list.
  #>

  [CmdletBinding()]

  Param(
    [Parameter(Mandatory, HelpMessage="File list.")]
    [SupportsWildcards()]
    [Alias('File', 'F')]
    [string[]]${Files}
  )

  ForEach ( ${File} in ( Get-ChildItem "${Files}" ) ) {
    ${FullName} = "$( ${File}.FullName )"
    ${Hash} = Get-FileHash "${FullName}" -Algorithm 'SHA1'
      | Select-Object 'Hash', @{ N = 'Path'; E = { $_.Path | Resolve-Path -Relative } }
    ${Hash} | Out-File "$( ${FullName} + '.sha1' )"

    Compress-7z -F "${FullName}" -T '7z' -L 9
  }
}
