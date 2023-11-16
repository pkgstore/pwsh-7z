function Compress-ISO() {
  <#
    .SYNOPSIS

    .DESCRIPTION
  #>

  Param(
    [Parameter(Mandatory)][Alias('I')][string]$P_In
  )

  (Get-Item $P_In) | ForEach-Object {
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
