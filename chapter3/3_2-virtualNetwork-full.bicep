//3_2-virtualNetwork-full.bicep
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
    subnets: [
      {
        name: 'bicepSubnet1'
        properties: {
          addressPrefix: '10.0.1.0/27'
        }
      }
      {
        name: 'bicepSubnet2'
        properties: {
          addressPrefix: '10.0.2.0/27'
        }
      }
    ]
  }
}
