BREAK

public const string MailPrimaryPrefix = "SMTP";
public const string MailSecondaryPrefix = "smtp";
public const string MailPagerPrefix = "smtp-pager";
 
internal static string[] emailTypes ={ "Primary","Secondary","Pager" };
 
internal static string[] emailPrefixes =  {MailPrimaryPrefix, MailSecondaryPrefix, MailPagerPrefix };
 
public string [] emailAddresses;
 
private void GetEmailAddresses()
{
System.DirectoryServices.PropertyCollection properties = userEntry.Properties;
 
PropertyValueCollection proxyAddresses = userEntry.Properties[“proxyAddresses”];
 
for (Int32 i=0; i<emailTypes.Length; i++)
{
string emailType = emailTypes[i];
string emailPredix = emailPrefixes[i];
string foundAddress = string.Empty;
 
if (proxyAddresses!=null)
{
foreach (string address in proxyAddresses)
{
if (address.StartsWith(emailPrefix+”:”))
{
foundAddress = address.Remove(0,emailPrefix.Length+1);
break;
}
}
}
emailAddresses[i] = foundAddress;
}
} // End of GetEmailAddresses call…
 
 
// Before calling this method, make sure the string
// collection emailAddresses[] is populated with the actual
// email addresses.
private void UpdateProxyAddresses()
{
// If / when this method detects the address as the primary
// email address, it also updates the [“mail”] property…
System.DirectoryServices.PropertyCollection properties = userEntry.Properties;
 
PropertyValueCollection proxyAddresses = userEntry.Properties[“proxyAddresses”];
 
if (proxyAddresses!=null)
{
for (Int32 i=0; i<emailAddresses.Length; i++)
{
string emailType = emailTypes[i];
string emailAddress = emailAddresses[i];
int schemaIndex = Array.IndexOf(emailTypes,emailType);
 
if (schemaIndex>-1)
{
// Is it the primary address?
if (schemaIndex==0)
userEntry.Properties[“mail”].Value = emailAddress.ToString();
 
string emailPrefix = emailPrefixes[schemaIndex];
 
bool found=false;
for (int j=0; j<proxyAddresses.Count; j++)
{
string proxyAddress = proxyAddresses[j].ToString();
if (proxyAddress.StartsWith(emailPrefix+”:”))
{
proxyAddresses[j] = emailPrefix + “:” + emailAddress;
found = true;
 
}
}
if (!found)
proxyAddresses.Add(emailPrefix + “:” + emailAddress);
}
 
// Update AD…
userEntry.Properties[“proxyAddresses”] = proxyAddresses;
}
}
}