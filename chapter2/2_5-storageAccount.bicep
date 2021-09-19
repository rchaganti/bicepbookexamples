// 2_5-storageAccount.bicep
resource stg 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: 'bicepstg002'
  location: 'eastus'
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    accessTier: 'Cool'
  }
}
