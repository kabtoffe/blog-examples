function ConvertTo-CustomObject{
    [CmdletBinding()]

    param(
        #Input the object to transform
        [Parameter(Mandatory=$True,ValueFromPipeline=$True)]
        $InputObject,

        #Column mappings
        [Parameter(Mandatory=$True)]
        [hashtable]$MappingTable
    )

    BEGIN {
        $PropertyMappings = @()
        $MappingTable.Keys | ForEach-Object {

            $PropertyMappings += (
                @"
                    @{
                        N="$($MappingTable[$_])"
                        E={`$_.$_}
                    }
"@
)
                    }
        #Join with a comma
        $PropertyMappingExpression = $PropertyMappings -join ","
        
        #Invoke the string expression and store it in a parameter
        $SelectObjectParameter = Invoke-Expression $PropertyMappingExpression
    }

    PROCESS {
        $InputObject | Select-Object -Property $SelectObjectParameter
    }    
}
