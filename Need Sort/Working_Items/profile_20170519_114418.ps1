if ($Host.Name -eq 'ConsoleHost')
{
    Import-Module PSReadline
    # differentiate verbose from warnings!
    $privData = (Get-Host).PrivateData
    $privData.VerboseForegroundColor = "cyan"
}
elseif ($Host.Name -like '*ISE Host')
{
    Start-Steroids
    Import-Module PsIseProjectExplorer
}
if (!$env:github_shell)
{
    # not sure why, but this fails in a git-flavored host
    Add-PSSnapin Microsoft.TeamFoundation.PowerShell
}