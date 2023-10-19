// Name        : linuxScript.bicep
// Description : Runs a Linux shell script as managed run command in a Linux VM
// Version     : 1.0.0
// Author      : github.com/rchaganti

// parameters
@description('VM name where this script needs to execute.')
param vmName string

@description('Type of the action performed by this script.')
param configType string

@description('Location of the VM.')
param location string

@description('Should this script be executed asynchronously. Default is false.')
param asyncExec bool = false

@description('Script content to be executed.')
param scriptContent string

@description('Parameters to pass to the script.')
param scriptParams array = []

@description('Protected parameters to pass to the script.')
param protecttedScriptParams array = []

@description('Script timeout in seconds. 300 is default.')
param timeout int = 300

// variables
var scriptSource = {
  script: scriptContent
}

// resources
resource mrc 'Microsoft.Compute/virtualMachines/runCommands@2022-08-01' = {
  name: '${vmName}/${configType}mrc'
  location: location
  properties: {
    asyncExecution: asyncExec
    parameters: scriptParams
    protectedParameters: protecttedScriptParams
    source: scriptSource
    timeoutInSeconds: timeout
  }
}

// output
output status object = mrc
