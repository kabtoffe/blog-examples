#Requires -modules Microsoft.Xrm.Data.PowerShell

function ConvertTo-CustomObject{
    [CmdletBinding()]

    param(
        #Input the object to transform
        [Parameter(Mandatory=$True,ValueFromPipeline=$True)]
        $SourceObject,

        #Column mappings
        [Parameter(Mandatory=$True)]
        [hashtable]$MappingTable
    )

    PROCESS {

        $Property = @{}
        $MappingTable.Keys | ForEach-Object {
            $Property.Add(
                #New header
                $MappingTable[$_],
                
                #Old value
                $SourceObject.$_
            )
        }

        New-Object psobject -Property $Property
    }    
}


#Connect to the Dynamics 365 instance of yout choice
Connect-CrmOnlineDiscovery -InteractiveMode

#Setup settings as variables
$EntityLogicalName = "account" #The logical name of the entity of the type of records to export

#The schema names of the attributes to export and new headers
$FieldsMappings = @{
    "name" = "AccountName"
    "telephone1" = "Phone"
} 

$OutputFile = "accounts.csv" #The filename of the output file

#Get all records of the selected type and pipe the output to Select-Object
(Get-CrmRecords -EntityLogicalName $EntityLogicalName -Fields ([string[]]$FieldsMappings.Keys) -AllRows).CrmRecords |
    #Convert our result object to a new object with the right attributenames and pipe the result to Export-CSV
    ConvertTo-CustomObject -MappingTable $FieldsMappings |
    #Output the results to CSV-file
    Export-Csv -Path $OutputFile -Encoding Default -NoTypeInformation