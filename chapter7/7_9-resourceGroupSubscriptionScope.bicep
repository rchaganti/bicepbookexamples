param resGroup string
param subId string

module stgAccct 'modules/storageAccount.bicep' = {
  name: 'stgAcct'
  scope: resourceGroup(subId, resGroup)
  params: {
    storageAccountName: 'bicepstgacctrc02'
  }
}
