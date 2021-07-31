param storageAccountPrefix string = 'bicep'
param enableStorageLock bool

var numUniqueChars = 24 - (length(storageAccountPrefix) + 1)

resource bicepstorage 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: '${storageAccountPrefix}${take(uniqueString(resourceGroup().id), numUniqueChars)}'
  location: 'eastus'
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    accessTier: 'Cool'
  }
}

resource bicepstoragelock 'Microsoft.Authorization/locks@2016-09-01' = if (enableStorageLock) {
  name: '${storageAccountPrefix}${take(uniqueString(resourceGroup().id), numUniqueChars)}'
  scope: bicepstorage
  properties: {
    level: 'ReadOnly'
    notes: 'This resource can neither be modified or deleted.'
  }
}
