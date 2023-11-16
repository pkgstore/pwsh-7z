$Aliases = @()
$PrivateFunctions = (Get-ChildItem -Path (Join-Path $PSScriptRoot 'Private') -Include '*.ps1' -File -Recurse)
$PublicFunctions = (Get-ChildItem -Path (Join-Path $PSScriptRoot 'Public') -Include '*.ps1' -File -Recurse)

(@($PrivateFunctions) + @($PublicFunctions)) | ForEach-Object {
  try {
    Write-Verbose "Loading '$($_.FullName)'."
    . $_.FullName
  } catch {
    Write-Warning $_.Exception.Message
  }
}

@($PublicFunctions) | ForEach-Object {
  $Alias = (Get-Alias -Definition $_.BaseName -ErrorAction 'SilentlyContinue')

  if ($Alias) {
    $Aliases += $Alias
    Export-ModuleMember -Function $_.BaseName -Alias $Alias
  } else {
    Export-ModuleMember -Function $_.BaseName
  }
}
