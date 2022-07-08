// 9_7-storageAccount.bicep
// param resLocation string = resourceGroup().location

resource stg 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: 'bicepstg002'
  location: resourceGroup().location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    accessTier: 'Cool'
  }
}
