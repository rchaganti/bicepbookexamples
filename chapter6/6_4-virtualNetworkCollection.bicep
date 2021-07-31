param vNetPrefix array = [
  '10.0.0.0/16'
]

param subnets array = [
  {
    name: 'subnet1'
    prefix: '10.0.1.0/27'
  }
  {
    name: 'subnet2'
    prefix: '10.0.2.0/27'
  }
]

resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: 'vnet'
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: vNetPrefix
    }
    subnets: [for sNet in subnets: {
      name: sNet.name
      properties: {
        addressPrefix: sNet.prefix
      }
    }]
  }
}

output subnetIds array = [for sNet in subnets: [
  resourceId('Microsoft.Storage/virtualNetworks/subnets', 'vnet','${sNet.name}')
]]
