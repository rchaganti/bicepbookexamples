param vNetPrefix string = 'bicep'
var vNetworks = [
  {
    addressPrefix: '10.1.0.0/24'
    subnets: [
      {
        addressPrefix: '10.1.0.0/26'
      }
      {
        addressPrefix: '10.1.0.64/26'
      }
      {
        addressPrefix: '10.1.0.128/26'
      }
    ]
  }
  {
    addressPrefix: '10.2.0.0/24'
    subnets: [
      {
        addressPrefix: '10.2.0.0/26'
      }
      {
        addressPrefix: '10.2.0.64/26'
      }
    ]
  }
  {
    addressPrefix: '10.3.0.0/24'
    subnets: [
      {
        addressPrefix: '10.3.0.0/26'
      }
    ]
  }
  {
    addressPrefix: '10.4.0.0/24'
    subnets: [
      {
        addressPrefix: '10.4.0.0/26'
      }
      {
        addressPrefix: '10.4.0.64/26'
      }
    ]
  }
]

@batchSize(2)
resource vNetwork 'Microsoft.Network/virtualNetworks@2021-02-01' = [for (vNet, vNetIndex) in vNetworks: {
  name: '${vNetPrefix}-vnet-${vNetIndex+1}'
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vNet.addressPrefix
      ]
    }
    subnets: [for (sNet, sNetIndex) in vNet.subnets: {
      name: 'subnet-${sNetIndex}'
      properties: {
        addressPrefix: sNet.addressPrefix
      }
    }]
  }
}]

output vNets array = [for (vnet, vNetIndex) in vNetworks: { 
  vNetName: '${vNetPrefix}-vnet-${vNetIndex+1}'
  subnetsPrefixes: '${vnet.subnets}'
}]
