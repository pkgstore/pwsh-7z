$ModuleManifest = (Get-ChildItem -Path $PSScriptRoot | Where-Object {$_.Extension -eq '.psd1'})
$CurrentManifest = (Test-ModuleManifest $ModuleManifest)

$Aliases = @()
$PrivateFunctions = (Get-ChildItem -Path (Join-Path $PSScriptRoot 'Private') | Where-Object {$_.Extension -eq '.ps1'})
$PublicFunctions = (Get-ChildItem -Path (Join-Path $PSScriptRoot 'Public') | Where-Object {$_.Extension -eq '.ps1'})

(@($PrivateFunctions) + @($PublicFunctions)) | ForEach-Object {
  try {
    Write-Verbose "Loading: '$($_.FullName)'."
    . $_.FullName
  } catch {
    $_.Exception.Message | Write-Warning
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

$FunctionsAdded = ($PublicFunctions | Where-Object {$_.BaseName -notin $CurrentManifest.ExportedFunctions.Keys})
$FunctionsRemoved = ($CurrentManifest.ExportedFunctions.Keys | Where-Object {$_ -notin $PublicFunctions.BaseName})
$AliasesAdded = ($Aliases | Where-Object {$_ -notin $CurrentManifest.ExportedAliases.Keys})
$AliasesRemoved = ($CurrentManifest.ExportedAliases.Keys | Where-Object {$_ -notin $Aliases})

if ($FunctionsAdded -or $FunctionsRemoved -or $AliasesAdded -or $AliasesRemoved) {
  try {
    $UpdateModuleManifestParams = @{}
    $UpdateModuleManifestParams.Add('Path', $ModuleManifest)
    $UpdateModuleManifestParams.Add('ErrorAction', 'Stop')

    if ($Aliases.Count -gt 0) {
      $UpdateModuleManifestParams.Add('AliasesToExport', $Aliases)
    }

    if ($PublicFunctions.Count -gt 0) {
      $UpdateModuleManifestParams.Add('FunctionsToExport', $PublicFunctions.BaseName)
    }

    Update-ModuleManifest @UpdateModuleManifestParams
  } catch {
    $_ | Write-Error
  }
}
