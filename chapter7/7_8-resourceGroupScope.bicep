targetScope = 'resourceGroup'
param resGroup string

module stgAcct 'modules/storageAccount.bicep' = {
  name: 'stgAcct'
  scope: resourceGroup(resGroup)
  params: {
    storageAccountName: 'bicepstgacctrc01'
  }
}
