//3_9-subscriptionScopedDeployment.bicep
targetScope = 'subscription'

resource rg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: 'rgTest'
  location: 'WestUS'
}
