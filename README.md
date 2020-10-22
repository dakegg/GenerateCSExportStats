# Generate-CSExportStats.ps1

This Powershell script will generate CSExport reports and capture statistics from each AAD Connect management agent (Connector) to XML and ZIP up the resulting files for submission.

The resulting ZIP file will be located in the C:\Program Files\Microsoft Azure AD Sync\Bin directory and will contain an XML with connector stats and an XML with all pending export errors for each Connector on the server.

![image](https://user-images.githubusercontent.com/19189243/96886681-700cfe80-1449-11eb-900d-89433a79fee0.png)

