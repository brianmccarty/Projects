#Required to load the XAML form and create the PowerShell Variables

.\loadDialog.ps1 -XamlPath '.\Forms\Interface3.xaml'
#This section imports the module which does all of the back end configuration, this module was taken from http://365lab.net/2014/01/07/managing-office-365-e-mail-addresses-easy-with-powershell-when-using-dirsync/ written by Andreas Lindahl 
Import-Module -Name .\O365ProxyAddresses.psm1
#This section grabs the username from the top text box and lists all of the addresses in the list box and all of the primary emails in the label on the right
#it will also throw an error if you enter an invalid username
$GetAliasBtn.add_click({
		try
		{
			$aliasLst.itemssource = (Get-O365AliasAddress $usernametbox.text | Format-List address | out-string Where-Objectam | Where-Object {
					$_ -ne ""
				}).replace("Address : ", "")
			$primaryemails = (Get-O365AliasAddress $usernametbox.text | Where-Object{
					$_.IsPrimary -eq $true
				} | Format-List address | Out-String | Where-Object {
					$_ -ne ""
				}).replace("Address : ", "")
			$primaryemaillbl.Content = ($primaryemails) -replace '(?m)^\s*\r?\n', ''
		}
		catch
		{
			[System.Windows.Forms.MessageBox]::show("Please enter a valid username", "Error", 0)
		}
	})
#This section gets the email address selcted in the list box prompts for confirmation then deletes that email address. It will then update the list of email addresses in the list box
$RemoveEmailBtn.add_click({
		$selectedaddr = $AliasLst.selecteditems
		$output = [System.Windows.Forms.MessageBox]::show("Are you sure you want to delete the email address: " + $selectedaddr, "Confirmation", 4)
		if ($output -eq "YES")
		{
			Remove-O365AliasAddress $usernametbox.Text -Address $selectedaddr
			$aliasLst.itemssource = (Get-O365AliasAddress $usernametbox.text | Format-List address | out-string -Stream | Where-Object {
					$_ -ne ""
				}).replace("Address : ", "")
		}
		else
		{
		}
	})
#This section will add the email addresses entered into the textbox to the username listed at the top of the screen, it also gives the option of setting this email address as primary
#and will then update both the address list and the primary address label
$AddEmailBtn.add_click({
		$newemailaddr = $AddEmailTbox.text
		if ($PrimaryTick.ischecked -eq $true)
		{
			Add-O365AliasAddress $UserNameTbox.Text -Address $newemailaddr -SetAsDefault
			$aliasLst.itemssource = (Get-O365AliasAddress $usernametbox.text | Format-List address | out-string -Stream | Where-Object {
					$_ -ne ""
				}).replace("Address : ", "")
			$primaryemails = (Get-O365AliasAddress $usernametbox.text | Where-Object{
					$_.IsPrimary -eq $true
				} | Format-List address | Out-String | Where-Object {
					$_ -ne ""
				}).replace("Address : ", "")
			$primaryemaillbl.Content = ($primaryemails) -replace '(?m)^\s*\r?\n', ''
		}
		else
		{
			Add-O365AliasAddress $UserNameTbox.Text -Address $newemailaddr
			$aliasLst.itemssource = (Get-O365AliasAddress $usernametbox.text | Format-List address | out-string -Stream | Where-Object {
					$_ -ne ""
				}).replace("Address : ", "")
		}
	})
#This section deletes an addresses then re-adds the same address as primary then updates the primary address label on the right hand side
$setexistingasdefault.add_click({
		$selectedaddr = $AliasLst.selecteditems
		Remove-O365AliasAddress $usernametbox.Text -Address $selectedaddr
		Add-O365AliasAddress $UserNameTbox.Text -Address $selectedaddr -SetAsDefault
		$primaryemails = (Get-O365AliasAddress $usernametbox.text | Where-Object{
				$_.IsPrimary -eq $true
			} | Format-List address | Out-String | Where-Object {
				$_ -ne ""
			}).replace("Address : ", "")
		$primaryemaillbl.Content = ($primaryemails) -replace '(?m)^\s*\r?\n', ''
	})


#Launch the window

$xamGUI.ShowDialog() | out-null