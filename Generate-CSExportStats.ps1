Write-Host -fore Green "Creating XML export from each connector..."

[array]$AllConnectors = Get-ADSyncConnector

[array]$ADConnectors = $AllConnectors | where { ($_.name -notlike "* - AAD" -and $_.type -like "*AD*") -or ($_name -notlike "* - AAD" -and $_.SubType -like "*LDAP*") } | select Name, Type, Identifier
[array]$AADConnectors = $AllConnectors | where { $_.name -like "* - AAD" } | select Name, Type, Identifier

foreach ($ADConnector in $ADConnectors)
{
	pushd 'C:\Program Files\Microsoft Azure AD Sync\Bin'
	.\csexport.exe $ADConnector.name "$($ADConnector.name).xml" /f:e
	Get-AdSyncConnectorStatistics $ADConnector.name  | Export-Clixml "Stats-$($ADConnector.name).xml"
}

foreach ($AADConnector in $AADConnectors)
{
	pushd 'C:\Program Files\Microsoft Azure AD Sync\Bin'
	.\csexport.exe $AADConnector.name "$($AADConnector.name).xml" /f:e
	Get-AdSyncConnectorStatistics $AADConnector.name | Export-Clixml "Stats-$($AADConnector.name).xml"
}

$Files = $null
$Files = get-childitem 'C:\Program Files\Microsoft Azure AD Sync\Bin' '*.xml' 

If ($files)
{
	
	Write-Host -fore Green "Creating temp folder for xml export"
	$tempfoldername = "$env:temp\$(Get-Date -format 'yyyyMMddhhmmss')"
	new-item $tempfoldername -ItemType Directory | Out-Null
	Write-Host -fore Yellow "Temp folder name is $tempfoldername"
	
	Write-Host -fore Yellow "File(s) to be Zipped : "
	Write-Host "$($files | out-string -width 79)"
	[dateTime]$Yesterday = (get-date).Date.AddDays(-1)
	
	$Destination = "C:\Program Files\Microsoft Azure AD Sync\Bin\XMLFiles-$($Yesterday.month)$($Yesterday.day)$($Yesterday.year).zip"
	Write-Host -fore Yellow "Destination ZIP file name : $destination"
	
	if (test-Path $Destination)
	{
		Write-Host "ZIP $Destination already exists, doing nothing."
		Write-Host -fore Red "Zip file $destination already exists, assuming this is because this function was run twice in the same day, doing nothing ..."
		Remove-Item $TempFolderName -force -recurse
		Break
	}
	
	Write-Host -fore Green "Moving files to temp folder to be zipped"
	$files | move-item -Destination $tempfoldername -force
	Add-Type -assembly "system.io.compression.filesystem"
	Write-Host -fore Green "Zipping files ..."
	[io.compression.zipfile]::CreateFromDirectory($TempFolderName, $Destination)
} # IF FILES




