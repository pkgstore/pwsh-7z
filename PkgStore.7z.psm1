function Compress-7z() {
  <#
    .SYNOPSIS
      Compress '7z' archive.

    .DESCRIPTION

    .PARAMETER F
      File list.

    .PARAMETER T
      Specifies type of archive.
      Value: ['7z' | 'BZIP2' | 'GZIP' | 'TAR' | 'WIM' | 'XZ' | 'ZIP'].
      Default: '7z'.

    .PARAMETER L
      Compression level.
      Value: [1 | ... | 9].
      Default: 5.

    .PARAMETER P
      Password. Encrypt both file data and headers.

    .PARAMETER D
      Delete files after compression.
  #>

  [CmdletBinding()]

  Param(
    [Parameter(Mandatory)]
    [SupportsWildcards()]
    [Alias('F')]
    [string[]]${Files},

    [ValidateSet('7z', 'BZIP2', 'GZIP', 'TAR', 'WIM', 'XZ', 'ZIP')]
    [Alias('T')]
    [string]${Type} = '7z',

    [ValidateRange(1,9)]
    [Alias('L')]
    [int]${Level} = 5,

    [Alias('P')]
    [string]${Password},

    [Alias('D')]
    [switch]${Delete} = $false
  )

  $7z = "${PSScriptRoot}\7z.exe"

  if (-not (Test-Path -Path "${7z}" -PathType "Leaf")) {
    Write-Error -Message "'7z.exe' not found!" -ErrorAction "Stop"
  }

  ForEach ( ${F} in ( Get-ChildItem ${Files} ) ) {
    ${FullName} = "$( ${F}.FullName )"
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

    .PARAMETER F
      File list.
  #>

  [CmdletBinding()]

  Param(
    [Parameter(Mandatory)]
    [SupportsWildcards()]
    [Alias('F')]
    [string[]]${Files}
  )

  $7z = "${PSScriptRoot}\7z.exe"

  if ( -not ( Test-Path -Path "${7z}" -PathType "Leaf" ) ) {
    Write-Error -Message "'7z.exe' not found!" -ErrorAction "Stop"
  }

  ForEach ( ${F} in ( Get-ChildItem ${Files} ) ) {
    ${FullName} = "$( ${F}.FullName )"
    ${CMD} = @( "x", "${FullName}" )

    & "${7z}" ${CMD}
  }
}

function Compress-ISO() {
  <#
    .SYNOPSIS
      Compress 'ISO' to archive.

    .DESCRIPTION

    .PARAMETER F
      File list.
  #>

  [CmdletBinding()]

  Param(
    [Parameter(Mandatory)]
    [SupportsWildcards()]
    [Alias('F')]
    [string[]]${Files}
  )

  ForEach ( ${F} in ( Get-ChildItem ${Files} ) ) {
    ${FullName} = "$( ${F}.FullName )"
    ${Hash} = Get-FileHash "${FullName}" -Algorithm 'SHA1'
      | Select-Object 'Hash', @{ N = 'Path'; E = { $_.Path | Resolve-Path -Relative } }
    ${Hash} | Out-File "$( ${FullName} + '.sha1' )"

    Compress-7z -F "${FullName}" -T '7z' -L 9
  }
}
