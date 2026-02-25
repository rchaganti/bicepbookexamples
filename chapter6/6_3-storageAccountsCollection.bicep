//6_3-storageAccountsCollection.bicep
param saNames array = [
  'sqllondon'
  'sqlchennai'
  'archiveseattle'
]

var uniqueSaNames = [for sName in saNames: '${sName}${take(uniqueString(resourceGroup().id), 24 - (length(sName) + 1))}']

resource sa 'Microsoft.Storage/storageAccounts@2023-05-01' = [for uSName in uniqueSaNames: {
  name: uSName
  location: resourceGroup().location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}]

output saIds array = [for sName in uniqueSaNames: [
  resourceId('Microsoft.Storage/storageAccounts', sName)
]]
