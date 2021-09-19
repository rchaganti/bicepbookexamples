//7_13-tenantScope.bicep
targetScope = 'managementGroup'

resource rgpResearch 'Microsoft.Management/managementGroups@2020-05-01' = {
  scope: tenant()
  name: 'Research'
  properties: {
    displayName: 'Research Group'
  }
}

resource grpManagement 'Microsoft.Management/managementGroups@2020-05-01' = {
  scope: tenant()
  name: 'Management'
  properties: {
    displayName: 'Management group'
    details: {
      parent: {
        id: rgpResearch.id
      }
    }
  }
}
