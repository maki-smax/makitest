#ps1_sysnative 
Try {
Start-Transcript -Path "C:\DomainJoin\stage1.txt" 
Install-WindowsFeature NET-Framework-Core 
Install-WindowsFeature AD-Domain-Services 
Install-WindowsFeature RSAT-ADDS
Install-WindowsFeature RSAT-DNS-Server
$addsmodule02 = @" 
#ps1_sysnative
Try {
Start-Transcript -Path C:\DomainJoin\stage2.txt
`$password = "Kbc123456"
`$FullDomainName = "ysk-box.local"
`$ShortDomainName = "YSK-BOX"
`$encrypted = ConvertTo-SecureString `$password -AsPlainText -Force 
Import-Module ADDSDeployment
Install-ADDSForest ``
-CreateDnsDelegation:`$false ``
-DatabasePath "C:\Windows\NTDS" ``
-DomainMode "WinThreshold" ``
-DomainName `$FullDomainName ``
-DomainNetbiosName `$ShortDomainName ``
-ForestMode "WinThreshold" ``
-InstallDns:`$true ``
-LogPath "C:\Windows\NTDS" ``
-NoRebootOnCompletion:`$false ``
-SysvolPath "C:\Windows\SYSVOL" ``
-SafeModeAdministratorPassword `$encrypted ``
-Force:`$true
} Catch { 
Write-Host $_
} Finally {
Stop-Transcript
}
"@
Add-Content -Path "C:\DomainJoin\ADDCmodule2.ps1" -Value $addsmodule02 
$RunOnceKey = "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
set-itemproperty $RunOnceKey "NextRun" ('C:\Windows\System32\WindowsPowerShell\v1.0\Powershell.exe -executionPolicy Unrestricted -File ' + "C:\DomainJoin\ADDCmodule2.ps1")
} Catch { 
Write-Host $_
} Finally {
Stop-Transcript
}
# Last step is to reboot the local host