function Compress-7z() {
  <#
    .SYNOPSIS
      Compress '7z' archive.

    .DESCRIPTION

    .PARAMETER Files
      File list.
      Alias: '-F'.

    .PARAMETER Type
      Specifies type of archive.
      Value: ['7z' | 'BZIP2' | 'GZIP' | 'TAR' | 'WIM' | 'XZ' | 'ZIP'].
      Default: '7z'.
      Alias: '-T'.

    .PARAMETER Level
      Compression level.
      Value: [1 | ... | 9].
      Default: 5.
      Alias: '-L'.

    .PARAMETER Password
      Password. Encrypt both file data and headers.
      Alias: '-P'.

    .PARAMETER Delete
      Delete files after compression.
      Alias: '-D'.

    .EXAMPLE
      Compress-7z -F '*.iso', '*.txt'

    .EXAMPLE
      Compress-7z -F '*.log' -T 'zip'

    .EXAMPLE
      Compress-7z -F '*.txt' -L 9

    .LINK
      Package Store: https://github.com/pkgstore

    .NOTES
      Author: Kitsune Solar <mail@kitsune.solar>
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

  # 7zip executable file.
  ${APP} = "${PSScriptRoot}\App\7z.exe"

  # Checking if a '7z.exe' exist.
  if ( -not ( Test-Path -Path "${APP}" -PathType "Leaf" ) ) {
    Write-Msg -T 'E' -M "'7z.exe' not found!" -A 'Stop'
  }

  ForEach ( ${F} in ( Get-ChildItem ${Files} ) ) {
    # Composing a app command.
    ${CMD} = @( "a", "-t${Type}", "-mx${Level}" )
    if ( -not ( [string]::IsNullOrEmpty(${Password}) ) ) { ${CMD} += @( "-p${Password}" ) }
    if ( ${Delete} ) { ${CMD} += @( "-sdel" ) }
    ${CMD} += @( "$( ${F}.FullName + '.' + ${Type}.ToLower() )", "$( ${F}.FullName )" )

    # Running a app.
    & "${APP}" ${CMD}
  }
}

function Expand-7z() {
  <#
    .SYNOPSIS
      Expand '7z' archive.

    .DESCRIPTION

    .PARAMETER Files
      File list.
      Alias: '-F'.

    .EXAMPLE
      Expand-7z -F '*.7z'

    .LINK
      Package Store: https://github.com/pkgstore

    .NOTES
      Author: Kitsune Solar <mail@kitsune.solar>
  #>

  [CmdletBinding()]

  Param(
    [Parameter(Mandatory)]
    [SupportsWildcards()]
    [Alias('F')]
    [string[]]${Files}
  )

  # 7zip executable file.
  ${APP} = "${PSScriptRoot}\App\7z.exe"

  # Checking if a '7z.exe' exist.
  if ( -not ( Test-Path -Path "${APP}" -PathType "Leaf" ) ) {
    Write-Msg -T 'E' -M "'7z.exe' not found!" -A 'Stop'
  }

  ForEach ( ${F} in ( Get-ChildItem ${Files} ) ) {
    # Composing a app command.
    ${CMD} = @( "x", "$( ${F}.FullName )" )

    # Running a app.
    & "${APP}" ${CMD}
  }
}

function Compress-ISO() {
  <#
    .SYNOPSIS
      Compress 'ISO' to archive.

    .DESCRIPTION

    .PARAMETER Files
      File list.
      Alias: '-F'.

    .EXAMPLE
      Compress-7z -F '*.iso'

    .LINK
      Package Store: https://github.com/pkgstore

    .NOTES
      Author: Kitsune Solar <mail@kitsune.solar>
  #>

  [CmdletBinding()]

  Param(
    [Parameter(Mandatory)]
    [SupportsWildcards()]
    [Alias('F')]
    [string[]]${Files}
  )

  ForEach ( ${F} in ( Get-ChildItem ${Files} ) ) {
    # Hash pattern.
    ${SHA1} = Get-FileHash "$( ${F}.FullName )" -Algorithm 'SHA1'
      | Select-Object 'Hash', @{ N = 'Path'; E = { $_.Path | Resolve-Path -Relative } }
    ${SHA1} | Out-File "$( ${F}.FullName + '.sha1' )"

    # Hash pattern.
    ${SHA256} = Get-FileHash "$( ${F}.FullName )" -Algorithm 'SHA256'
      | Select-Object 'Hash', @{ N = 'Path'; E = { $_.Path | Resolve-Path -Relative } }
    ${SHA256} | Out-File "$( ${F}.FullName + '.sha256' )"

    # Compressing a '*.ISO' file.
    Compress-7z -F "$( ${F}.FullName )" -T '7z' -L 9
  }
}
