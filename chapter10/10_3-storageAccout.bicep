// 10_3-storageAccount.bicep
param stgAccountName string
param resLocation string = resourceGroup().location
var stgAccountConfig = loadJsonContent('10_2-storageDefaults.json')

resource stgAccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: stgAccountName
  location: resLocation
  kind: stgAccountConfig.kind
  sku: {
    name: stgAccountConfig.sku
  }
  properties: {
    minimumTlsVersion: stgAccountConfig.properties.minimumTlsVersion
  }
}
