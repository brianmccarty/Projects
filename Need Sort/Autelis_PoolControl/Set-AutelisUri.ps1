<#	
	.NOTES
	===========================================================================
	 Created with: 	PowerShell Studio 2017, 5.4.140
	 Created on:   	5/29/2017 6:31 PM
	 Created by:   	Brian McCarty - bmccarty@cpisolutions.com
	 Organization: 	CPI Solutions
	 Filename:     	Set-AutelisUri.ps1
	===========================================================================
	.SYNOPSIS
		Short description
	.DESCRIPTION
		A description of the file
	.EXAMPLE
	   Example of how to use this cmdlet
	.EXAMPLE
	   Another example of how to use this cmdlet
#>
function Set-AutelisUri
{
	[CmdletBinding()]
	[Alias()]
	[OutputType([int])]
	Param
	(
		# Param1 help description
		[Parameter(Mandatory = $true,
				   ValueFromPipelineByPropertyName = $true,
				   Position = 0)]
		$Param1,
		# Param2 help description

		[int]$Param2
	)
	
	Begin
	{
	}
	Process
	{
	}
	End
	{
	}
}