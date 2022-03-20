targetScope = 'subscription'

param resGroupName string
param resGroupLocation string

resource rg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: resGroupName
  location: resGroupLocation
}
