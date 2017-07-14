$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "ConvertTo-CustomObject" {
    
    $SourceObject = New-Object psobject -Property @{
        "name" = "Test"
        "age" = 75
    }

    $MappingTable = @{
        "name" = "NewName"
        "age" = "NewAge"
    } 
    
    
    It "Convert OK" {
        $TargetObject = $SourceObject | ConvertTo-CustomObject -MappingTable $MappingTable
        $TargetObject.NewName | Should Be "Test"
        $TargetObject.NewAge | Should Be 75
        $TargetObject.name | Should Be $null
    }

    $MappingTable.Add(
        "NonExistantProperty",
        "NewProperty"
    )

    It "Non existant property" {
        $TargetObject = $SourceObject | ConvertTo-CustomObject -MappingTable $MappingTable
        $TargetObject.NewName | Should Be "Test"
        $TargetObject.NewAge | Should Be 75
        $TargetObject.name | Should Be $null
        $TargetObject.NewProperty | Should Be $null
    }

    It "Multiple objects" {
        $result = $SourceObject,(New-Object psobject -Property @{ "age" = 7 }) | ConvertTo-CustomObject -MappingTable $MappingTable

        $result.Count | Should Be 2
        $result[1].NewAge | Should Be 7
    }
    
}
