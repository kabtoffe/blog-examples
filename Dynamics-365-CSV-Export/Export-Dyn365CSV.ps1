#Requires -modules Microsoft.Xrm.Data.PowerShell

#Connect to the Dynamics 365 instance of yout choice
Connect-CrmOnlineDiscovery -InteractiveMode

#Setup settings as variables
$EntityLogicalName = "account" #The logical name of the entity of the type of records to export
$FieldsToExport = "name","telephone1" #The schema names of the attributes to export
$OutputFile = "accounts.csv" #The filename of the output file

#Get all records of the selected type and pipe the output to Select-Object
(Get-CrmRecords -EntityLogicalName $EntityLogicalName -Fields $FieldsToExport -AllRows).CrmRecords |
    #Only include the attributes that are to be exported and pipe the result to Export-CSV
    Select-Object -Property $FieldsToExport |
    #Output the results to CSV-file
    Export-Csv -Path $OutputFile -Encoding Default -NoTypeInformation