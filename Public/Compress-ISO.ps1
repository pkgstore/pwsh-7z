function Compress-ISO() {
  <#
    .SYNOPSIS
    Compressing ISO Images.

    .DESCRIPTION
    Compressing ISO images using 7-Zip.
    Calculate the hash sum of the image and compress the image with compression level 9.

    .PARAMETER In
    Input data.

    .EXAMPLE
    Compress-ISO -In '*.ISO'
  #>

  param(
    [Parameter(Mandatory)][Alias('I')][string[]]$In
  )

  (Get-Item $In) | ForEach-Object {
    $I = "$($_.FullName)"
    # Hash 'SHA1' pattern.
    $SHA1 = Get-FileHash "${I}" -Algorithm 'SHA1'
      | Select-Object 'Hash', @{N = 'Path'; E = {$_.Path | Resolve-Path -Relative}}
    $SHA1 | Out-File "$($I + '.sha1')"

    # Hash 'SHA256' pattern.
    $SHA256 = Get-FileHash "${I}" -Algorithm 'SHA256'
      | Select-Object 'Hash', @{N = 'Path'; E = {$_.Path | Resolve-Path -Relative}}
    $SHA256 | Out-File "$($I + '.sha256')"

    # Compressing a '*.ISO' file.
    Compress-7z -I "${I}" -L 9
  }
}
