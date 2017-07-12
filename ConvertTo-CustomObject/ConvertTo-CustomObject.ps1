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
        $PropertyMappingExpression = $PropertyMappingExpression.Substring(0,$PropertyMappingExpression.Length-1)
        $SelectObjectParameter = Invoke-Expression $PropertyMappingExpression
    }

    PROCESS {
        $SourceObject | Select-Object -Property $SelectObjectParameter
    }    
}
