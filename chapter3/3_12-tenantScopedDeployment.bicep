//3_12-tenantScopedDeployment.bicep
targetScope = 'tenant'

param mgName string = 'bicepmg'
param mgDisplayName string = 'Bicep Management Group'

resource bicepmg 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: mgName
  properties: {
    displayName: mgDisplayName
  }
}
