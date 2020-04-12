function Get-O365AliasAddress {
<#
.SYNOPSIS
    Displays all email addresses assigned to a user. 
.PARAMETER Identity
    The user to query. 
.EXAMPLE
    Get-O365AliasAddress -Identity user01
.EXAMPLE
    Get-ADUser user01 | Get-O365AliasAddress
#>

    [CmdletBinding()] 
    param (
        [Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$True,ValueFromPipeline=$True,
        HelpMessage="The name of the user to get addresses of")] 
        [string]$Identity
    )

    import-module ActiveDirectory

    $result = @()
    
    (Get-ADUser -Identity $Identity -Properties proxyAddresses).proxyAddresses | ForEach-Object {
        $proxy =  $_.split(":")
        $object = New-Object System.Object
        $object | Add-Member -Type NoteProperty -Name Type -Value $proxy[0]
        $object | Add-Member -Type NoteProperty -Name Address -Value $proxy[1]
        $object | Add-Member -Type NoteProperty -Name IsPrimary -Value ($proxy[0] -ceq $($proxy[0].ToUpper()))
        $result += $object
    }
    return $result
}

function Add-O365AliasAddress {
<#
.SYNOPSIS
    Adds an alias address to a user. 
.PARAMETER Identity
    The user to modify. 
.PARAMETER Address
    The address to add.
.PARAMETER Type
    The type of address. Default is smtp.
.PARAMETER SetAsDefault
    Indicates if the address should be de default address of the user
.EXAMPLE
    Add-O365AliasAddress -Identity user01 -Address test@365lab.net -SetAsPrimary
#>

    [CmdletBinding()] 
    param (
        [Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$True,ValueFromPipeline=$True,
        HelpMessage="The name of the user")] 
        [string]$Identity,

        [Parameter(Mandatory=$True,
        HelpMessage="The address to add")] 
        [string]$Address,

        [Parameter(
        HelpMessage="The type of the address to add")] 
        [string]$Type="smtp",

        [Parameter(
        HelpMessage="Indicates that the address will be set as the default address")] 
        [switch]$SetAsDefault
    )
    
    import-module ActiveDirectory
    
    $Type = $Type.ToLower()
        
    $defaultaddress = ""
    $proxyaddresses = ""
    $proxyaddress = ""

    #Get all existing proxyAddresses of the same type
    $proxyaddresses = (Get-AdUser -Identity $Identity -Properties proxyAddresses).proxyAddresses | where-object { $_ -like "$Type*" }
    
    #Get current default address of this type
    foreach ($proxyaddress in $proxyaddresses) {
        $pa = $proxyaddress.split(":")
        if ($pa[0] -ceq $pa[0].ToUpper()) {
            $defaultaddress = $proxyaddress
        }
    }

    #If this is the first address, it will be the default 
    if ($proxyaddresses.count -eq 0) {
        $SetAsDefault = $true
    }

    if ($SetAsDefault) { 
        
        #New default address to set. Start by removing the old one, but keep it as alias. 
        if ($defaultaddress) {
            $pa = $defaultaddress.split(":")
            $newdefaultaddress = "$($pa[0].ToLower()):$($pa[1])"
            Set-AdUser -Identity $Identity -Remove @{proxyaddresses=$defaultaddress} -Add @{proxyaddresses=$newdefaultaddress}
        }
        
        #Set new default address. In case it already exists, remove it first (it might already be used as alias)
        if ($Type -eq "SMTP") {
            Set-AdUser -Identity $Identity -Remove @{proxyaddresses="$($Type.ToLower()):$Address" } -Add @{proxyaddresses="$($Type.ToUpper()):$Address" } -EmailAddress $Address
        } else {
            Set-AdUser -Identity $Identity -Remove @{proxyaddresses="$($Type.ToLower()):$Address" } -Add @{proxyaddresses="$($Type.ToUpper()):$Address" }
        }

    } else {
        #Just add the new address
        Set-AdUser -Identity $Identity -Add @{proxyaddresses="$($Type):$Address" }
    }
}


function Remove-O365AliasAddress {
<#
.SYNOPSIS
    Removes an alias address from a user. 
.PARAMETER Identity
    The user to modify. 
.PARAMETER Address
    The address to remove.
.PARAMETER Type
    The type of address. Default is smtp.
.EXAMPLE
    Remove-O365AliasAddress -Identity user01 -Address test@365lab.net
#>

    [CmdletBinding()] 
    param (
        [Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$True,ValueFromPipeline=$True,
        HelpMessage="The name of the user")] 
        [string]$Identity,

        [Parameter(Mandatory=$True,
        HelpMessage="The address to remove")] 
        [string]$Address,

        [Parameter(
        HelpMessage="The type of the address to remove")] 
        [string]$Type="smtp"

    )
    
    import-module ActiveDirectory
    
    $Type = $Type.ToLower()
    $defaultaddress = ""
    $newdefaultaddress = ""
    $proxyaddresses = ""
    
    #Get all existing proxyAddresses of the same type
    $proxyaddresses = (Get-AdUser -Identity $Identity -Properties proxyAddresses).proxyAddresses | where-object { $_ -like "$Type*" }
    
    #Get current default address of this type
    foreach ($proxyaddress in $proxyaddresses) {
        $pa = $proxyaddress.split(":")
        if ($pa[0] -ceq $pa[0].ToUpper()) {
            $defaultaddress = $proxyaddress
        }
    }

    if ($defaultaddress -eq "$($Type):$Address") {
        #We are trying to remove the default address. Now it becomes a bit tricky...
        #First, find the next address of the same type that we can use as default address
        foreach ($proxyaddress in $proxyaddresses) {
            if ($proxyaddress -ne "$($Type):$Address") {
                $newdefaultaddress = $proxyaddress
                break
            }
        }
    }

    #Now we can remove the address
    Set-AdUser -Identity $Identity -Remove @{proxyaddresses="$($Type):$Address"}
    if ($Type -eq "smtp" -and $defaultaddress -eq "$($Type):$Address") {
        Set-AdUser -Identity $Identity -Clear mail
    }

    if ($newdefaultaddress) {
        #Set $newdefaultaddress as new default address
        Write-Warning "New default address set: $newdefaultaddress" 
        Add-O365AliasAddress -Identity $Identity -Address $newdefaultaddress.split(":")[1] -Type $Type -SetAsDefault
    }
}
