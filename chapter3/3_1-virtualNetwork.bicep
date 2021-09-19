//3_1-virtualNetwork.bicep
resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: 'bicepvnet'
  location: 'eastus'
  tags: {
    deparment: 'Engineering'
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
  }
}
