@allowed([
  'new'
  'existing'
])
param newOrExisting string

param storageAccountPrefix string = 'bicep'
param numStorageAccounts int = 3

resource bicepstorage 'Microsoft.Storage/storageAccounts@2021-04-01' = [for index in range(0,numStorageAccounts): if (newOrExisting == 'new') {
  name: '${storageAccountPrefix}stg${index}'
  location: resourceGroup().location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    accessTier: 'Cool'
  }
}]
