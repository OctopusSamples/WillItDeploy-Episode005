Import-Module WebAdministration

# Copy module binaries to website modules path
$adminModulePath = $OctopusParameters["Octopus.Action[Deploy Admin module].Output.Package.InstallationDirectoryPath"]
$websitePath = $OctopusParameters["Octopus.Action[Deploy Website].Output.Package.InstallationDirectoryPath"]
$websiteModulesPath = "$websitePath\Modules\Admin\bin\"
New-Item -ItemType Directory -Force -Path $websiteModulesPath
Copy-Item -Path "$adminModulePath\*" -Destination "$websiteModulesPath"

# Recycle website app pool
$appPoolName = "ap-$TenantWebName"
if (Test-Path IIS:\AppPools\$appPoolName){
if ((Get-WebAppPoolState($appPoolName)).Value -eq "Stopped"){
    Write-Output "Starting IIS app pool $appPoolName"
    Start-WebAppPool $appPoolName
}
else {
    Write-Output "Restarting IIS app pool $appPoolName"
    Restart-WebAppPool $appPoolName
}
}