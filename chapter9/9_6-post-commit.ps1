[CmdletBinding()]
param
(
    [Parameter()]
    [String]
    $CommitMessage
)

$action = [regex]::Matches($CommitMessage, '(?<=\[)[^]]+(?=\])').Value
$buildPath = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

function buildBicep
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [String]
        $BuildPath
    )
    
    Write-Host -ForegroundColor Green "[Build] Building Bicep template"
    bicep build "${buildPath}\main.bicep"
    if ($LASTEXITCODE -ne 0)
    {
        return $false
    }
    return $true
} 

if ($action.Count -ge 1)
{
    switch ($action)
    {
        "Build" {
            $buildStatus = buildBicep -BuildPath $buildPath
            if (!$buildStatus)
            {
                Write-Error "Failed to build the Bicep template"
                exit 1
            }
            break
        }

        "Deploy" {
            $buildStatus = buildBicep -BuildPath $buildPath
            if (!$buildStatus)
            {
                Write-Error "Failed to build the Bicep template"
                exit 1
            }

            Write-Host "[Deploy] Deploying Bicep template" -ForegroundColor Green
            $resourceGroup = $action[1]

            if (!$resourceGroup)
            {
                Write-Error "No resource group specified"
                exit 1
            }

            Write-Host "Starting Bicep template deployment" -ForegroundColor Green
            az deployment group create --resource-group $resourceGroup --template-file "${buildPath}\main.bicep"
            if ($LASTEXITCODE -ne 0)
            {
                Write-Error "Failed to deploy the Bicep template"
            }
            break
        }
        
        default {
            Write-Error "Invalid action specified"
        }
    }
}
else {
    Write-Host "No action specified" -ForegroundColor Red
}