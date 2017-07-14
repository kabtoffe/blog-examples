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
        $PropertyMappingExpression = ""
        $MappingTable.Keys | ForEach-Object {

            $PropertyMappingExpression += (
                @"
                    @{
                        N="$($MappingTable[$_])"
                        E={`$_.$_}
                    },
"@
)
                    }
        #Remove the last trailing comma
        $PropertyMappingExpression = $PropertyMappingExpression.Substring(0,$PropertyMappingExpression.Length-1)
        
        #Invoke the string expression and store it in a parameter
        $SelectObjectParameter = Invoke-Expression $PropertyMappingExpression
    }

    PROCESS {
        $InputObject | Select-Object -Property $SelectObjectParameter
    }    
}
