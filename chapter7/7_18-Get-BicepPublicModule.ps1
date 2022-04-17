[CmdletBinding()]
param
(

)

$mcrUrl = 'https://mcr.microsoft.com/v2/_catalog'
$allRepos = (Invoke-RestMethod -Uri $mcrUrl -ErrorAction SilentlyContinue).repositories

$moduleList = [System.Collections.ArrayList]@()

if ($allRepos)
{  
    $bicepRepos = $allRepos.Where({$_.StartsWith('bicep')})

    foreach ($bicepRepo in $bicepRepos)
    {        
        $tagsUrl = ("https://mcr.microsoft.com/v2/{0}/tags/list" -f $bicepRepo)
        $tagsObject = Invoke-RestMethod -Uri $tagsUrl
        $null = $moduleList.Add([PSCustomObject]@{
            Name = $tagsObject.Name
            Tags = $tagsObject.tags
        })
    }
}

return $moduleList