function Get-FilteredFeed{
    [CmdletBinding()]

    param(
        #Input feed xml content
        [Parameter(Mandatory=$True)]
        [xml]$FeedXml,

        #Category to keep
        [Parameter(Mandatory=$True)]
        [string]$Category
    )

    $FeedXml.feed.entry |
        Where-Object {
            !($_.category.term -contains $Category)
        } |
        ForEach-Object {
            $FeedXml.feed.RemoveChild($_) > $null
        }

    $FeedXml.OuterXml
}