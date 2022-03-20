//3_7-storageAccountLock.bicep
resource bicepstorage 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: 'bicepstgacct'
  location: 'eastus'
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    accessTier: 'Cool'
  }
}

resource bicepstoragelock 'Microsoft.Authorization/locks@2016-09-01' = {
  name: 'bicepstoragelock'
  scope: bicepstorage
  properties: {
    level: 'ReadOnly'
    notes: 'This resource can neither be modified or deleted.'
  }
}
