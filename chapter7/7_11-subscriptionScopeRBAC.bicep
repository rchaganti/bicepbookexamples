//7_11-subscriptionScopeRBAC.bicep
targetScope = 'subscription'

param resGroup string
param principalId string
param roleDefinitionId string = 'b24988ac-6180-42a0-ab88-20f7382dd24c'
param roleAssignmentName string = guid(principalId, roleDefinitionId, resGroup)

var roleID = '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/${roleDefinitionId}'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2019-10-01' existing = {
  name: resGroup
}

module applyLock 'modules/resourceLock.bicep' = {
  name: 'applyLock'
  scope: resourceGroup
}

module assignRole 'modules/resourceRole.bicep' = {
  name: 'assignRBACRole'
  scope: resourceGroup
  params: {
    principalId: principalId
    roleNameGuid: roleAssignmentName
    roleDefinitionId: roleID
  }
}
