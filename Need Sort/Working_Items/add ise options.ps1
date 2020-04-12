$psISE.CurrentPowerShellTab.AddOnsMenu.SubMenus.Add(
    "Connect to Exchange On-Premise", {
        Add-PSSnapin Microsoft.Exchange.Management.PowerShell.E2010
        . $env:ExchangeInstallPath\bin\RemoteExchange.ps1
        Connect-ExchangeServer –auto
            },
    "Control+Alt+1"
)
$psISE.CurrentPowerShellTab.AddOnsMenu.SubMenus.Add(
    "Connect to Exchange Online", {
        $o365Cred= Get-Credential
        $o365Session= New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $o365Cred -Authentication Basic -AllowRedirection
        Import-PSSession $o365Session
    },
    "Control+Alt+2"
)