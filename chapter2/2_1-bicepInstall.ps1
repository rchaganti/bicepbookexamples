[CmdletBinding()]
param
(
)

$url = 'https://github.com/Azure/bicep/releases/latest/download/bicep-setup-win-x64.exe'
$bicepFilePath = "${ENV:TEMP}\bicep-setup-win-x64.exe"

try
{
    # Download Bicep Installer
    Write-Verbose -Message 'Downloading the Bicep CLI installer.'
    Invoke-WebRequest -UseBasicParsing -Uri $url -OutFile $bicepFilePath

    # Install Bicep CLI
    Write-Verbose -Message 'Installing Bicep CLI'
    $bicepInstall = Start-Process -FilePath $bicepFilePath -ArgumentList '/verysilent /supressmsgboxes' -PassThru

    # Wait for installer to complete
    while (!$bicepInstall.HasExited)
    {
        Write-Verbose -Message 'Waiting for Bicep installer to complete installation.'
        Start-Sleep -Seconds 5   
    }

    # Update Path environment variable
    if ($bicepInstall.HasExited -and $bicepInstall.ExitCode -eq 0)
    {
        Write-Verbose -Message 'Bicep CLI installed. Updating Path variable in the current session.'
        $env:Path = [System.Environment]::GetEnvironmentVariable('Path','User')
        bicep --version
    }
    else
    {
        Write-Error "Bicep installer existed with an exit code: $($bicepInstall.ExitCode)."
    }

    # If exists, delete the Bicep installer
    if (Test-Path -Path $bicepFilePath)
    {
        Remove-Item -Path $bicepFilePath -Force
    }
}
catch
{
    Write-Error -Message 'Error occurred during Bicep CLI install.'
    Write-Error -Message $_ 
}