[cmdletbinding()]
param(
    $task = 'default'
)

#　BootStrap nuget packageprovider
write-debug $PSScriptRoot
Get-PackageProvider -Name NuGet -ForceBootstrap  | Out-Null
$ModuleRequrementsPath = Join-Path -Path $PSScriptRoot -ChildPath "requirements.psd1"
Write-Debug "ModuleRequirementsPath = $ModuleRequrementsPath"
$MustRequiredModule = @(
    @{name = 'psdepend' }
    # @{name = 'psake' }
    # @{name = 'pester'; MinimumVersion = 4.1 ; SkipPublisherCheck = $true }
)

$MustRequiredModule | ForEach-Object {
    if (Get-Module -Name $_.name -ListAvailable) {

    } else {
        Install-Module  @_ -force -AllowClobber -Scope 'CurrentUser'
    }

    # Import the module
    Import-Module $_.name 
}


if (Test-Path -Path $ModuleRequrementsPath) {
    Write-Debug "install depends"
    Invoke-PSDepend -Path $ModuleRequrementsPath -Install -Import -Force -WarningAction SilentlyContinue
}

if ($task) {
    if (test-path "$PSScriptRoot\psake.ps1") {
        Write-Debug "run task $task"
        Set-BuildEnvironment
        Invoke-psake -buildFile "$PSScriptRoot\psake.ps1" -taskList $task
    } else {
        Write-Error "$PSScriptRoot\psake.ps1 Not Found"
    }
}
