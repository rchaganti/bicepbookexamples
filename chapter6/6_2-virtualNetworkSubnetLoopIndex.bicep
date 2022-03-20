//6_2-virtualNetworkSubnetLoopIndex.bicep
var numSubnets = 2
var subnetPrefix = [
  '10.0.1.0/27'
  '10.0.2.0/27'
]

resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: 'vnet'
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [for sIndex in range(0, numSubnets): {
      name: 'subnet${sIndex}'
      properties: {
        addressPrefix: subnetPrefix[sIndex]
      }
    }]
  }
}

output subnetIds array = [for outIndex in range(0, numSubnets): [
  resourceId('Microsoft.Storage/virtualNetworks/subnets', 'vnet','subnet${outIndex}')
]]
