//6_1-storageAccountLoopIndex.bicep
param resourcePrefix string = 'bicep'

@minValue(2)
@maxValue(5)
param numStorageAccount int = 2

var numUniqueCharacters = 24 - (length(resourcePrefix) + 1)

var storageAccountNames = [for varIndex in range(0, numStorageAccount): '${resourcePrefix}${varIndex}${take(uniqueString(resourceGroup().id), numUniqueCharacters)}']

resource sa 'Microsoft.Storage/storageAccounts@2021-04-01' = [for index in range(0, numStorageAccount): {
  name: '${storageAccountNames[index]}'
  location: resourceGroup().location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
  	accessTier: 'Hot'
  }
}]

output saIds array = [for outIndex in range(0, numStorageAccount): [
  resourceId('Microsoft.Storage/storageAccounts', '${storageAccountNames[outIndex]}')
]]
