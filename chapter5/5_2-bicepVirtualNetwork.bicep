//5_2-bicepVirtualNetwork.bicep
param vNetPrefix string = 'bicep'

param subnetPrefix string = 'bicep'

var location = resourceGroup().location
var vNetAddressPrefix = '10.0.0.0/16'
var subnetAddressPrefix = [
  '10.0.1.0/27'
  '10.0.2.0/27'
]

resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: '${vNetPrefix}-Net'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vNetAddressPrefix
      ]
    }
  }
  
  resource sb1 'subnets' = {
    name: '${subnetPrefix}-subnet1'
    properties: {
      addressPrefix: subnetAddressPrefix[0]
    }
  }

  resource sb2 'subnets' = {
    name: '${subnetPrefix}-subnet2'
    properties: {
      addressPrefix: subnetAddressPrefix[1]
    }
  }
}
