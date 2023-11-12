@{
  RootModule = 'PkgStore.7z.psm1'
  ModuleVersion = '0.1.0'
  GUID = '613eb0b0-1b1e-4f28-92c9-1c6e73e91a1a'
  Author = 'Kitsune Solar'
  CompanyName = 'iHub.TO'
  Copyright = '(c) 2023 Kitsune Solar. All rights reserved.'
  Description = 'Compress end expand 7z archive.'
  PowerShellVersion = '7.2'
  RequiredModules = @('PkgStore.Kernel')
  FunctionsToExport = @('Compress-7z', 'Expand-7z', 'Compress-ISO')
  PrivateData = @{
    PSData = @{
      Tags = @('pwsh', '7z', '7zip')
      LicenseUri = 'https://github.com/pkgstore/pwsh-7z/blob/main/LICENSE'
      ProjectUri = 'https://github.com/pkgstore/pwsh-7z'
    }
  }
}
