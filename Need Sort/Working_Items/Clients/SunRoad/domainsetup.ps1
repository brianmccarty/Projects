Login-AzureRmAccount
Import-Module MSOnline
Connect-MsolService

New-MsolDomain -Name KMInfiniti.com
New-MsolDomain -Name BMWofElCajon.com
New-MsolDomain -Name KMHyundaiSubaru.com
New-MsolDomain -Name PacificHonda.com
New-MsolDomain -Name MaderasGolf.com
New-MsolDomain -Name ToyotaCV.com
New-MsolDomain -Name KearnyPearsonFord.com
New-MsolDomain -Name KPFord.com
New-MsolDomain -Name SDMarina.com
New-MsolDomain -Name Sunroad.co
New-MsolDomain -Name MidwayJeep.com
New-MsolDomain -Name SunroadEnterprises.com

Get-MsolDomainVerificationDNS -DomainName SanDiegoCDJR.com
Get-MsolDomainVerificationDNS -DomainName KMInfiniti.com
Get-MsolDomainVerificationDNS -DomainName BMWofElCajon.com
Get-MsolDomainVerificationDNS -DomainName KMHyundaiSubaru.com
Get-MsolDomainVerificationDNS -DomainName PacificHonda.com
Get-MsolDomainVerificationDNS -DomainName MaderasGolf.com
Get-MsolDomainVerificationDNS -DomainName ToyotaCV.com
Get-MsolDomainVerificationDNS -DomainName KearnyPearsonFord.com
Get-MsolDomainVerificationDNS -DomainName KPFord.com
Get-MsolDomainVerificationDNS -DomainName SDMarina.com
Get-MsolDomainVerificationDNS -DomainName Sunroad.co
Get-MsolDomainVerificationDNS -DomainName MidwayJeep.com
Get-MsolDomainVerificationDNS -DomainName SunroadAuto.com
Get-MsolDomainVerificationDNS -DomainName sunroadautomotive.com
Get-MsolDomainVerificationDNS -DomainName SunroadEnterprises.com

Confirm-MsolDomain -TenantId f0b5615d-058b-4425-b73f-7bd27242e7ed -DomainName SanDiegoCDJR.com
Confirm-MsolDomain -TenantId f0b5615d-058b-4425-b73f-7bd27242e7ed -DomainName KMInfiniti.com
Confirm-MsolDomain -TenantId f0b5615d-058b-4425-b73f-7bd27242e7ed -DomainName BMWofElCajon.com
Confirm-MsolDomain -TenantId f0b5615d-058b-4425-b73f-7bd27242e7ed -DomainName KMHyundaiSubaru.com
Confirm-MsolDomain -TenantId f0b5615d-058b-4425-b73f-7bd27242e7ed -DomainName PacificHonda.com
Confirm-MsolDomain -TenantId f0b5615d-058b-4425-b73f-7bd27242e7ed -DomainName MaderasGolf.com
Confirm-MsolDomain -TenantId f0b5615d-058b-4425-b73f-7bd27242e7ed -DomainName ToyotaCV.com
Confirm-MsolDomain -TenantId f0b5615d-058b-4425-b73f-7bd27242e7ed -DomainName KearnyPearsonFord.com
Confirm-MsolDomain -TenantId f0b5615d-058b-4425-b73f-7bd27242e7ed -DomainName KPFord.com
Confirm-MsolDomain -TenantId f0b5615d-058b-4425-b73f-7bd27242e7ed -DomainName SDMarina.com
Confirm-MsolDomain -TenantId f0b5615d-058b-4425-b73f-7bd27242e7ed -DomainName Sunroad.co
Confirm-MsolDomain -TenantId f0b5615d-058b-4425-b73f-7bd27242e7ed -DomainName MidwayJeep.com
Confirm-MsolDomain -TenantId f0b5615d-058b-4425-b73f-7bd27242e7ed -DomainName SunroadAuto.com
Confirm-MsolDomain -TenantId f0b5615d-058b-4425-b73f-7bd27242e7ed -DomainName sunroadent.com
Confirm-MsolDomain -TenantId f0b5615d-058b-4425-b73f-7bd27242e7ed -DomainName sunroadautomotive.com
Confirm-MsolDomain -TenantId f0b5615d-058b-4425-b73f-7bd27242e7ed -DomainName SunroadEnterprises.com

