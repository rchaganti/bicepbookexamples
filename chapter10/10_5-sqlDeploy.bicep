// 10_5-sqlDeploy.bicep
param subscriptionId string = '5073fa4c-1234-2314-8371-21e034f70820'
param kvResourceGroup string = 'bicep'
param kvName string = 'bicepkvault'
param resLocation string = resourceGroup().location

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: kvName
  scope: resourceGroup(subscriptionId, kvResourceGroup )
}

module deploySQL '10_4-sql.bicep' = {
  name: 'deploySQL'
  params: {
    resLocation: resLocation
    adminPassword: keyVault.getSecret('sqlPassword')
  }
}
