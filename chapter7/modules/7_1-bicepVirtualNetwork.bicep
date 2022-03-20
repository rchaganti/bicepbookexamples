// 7_1-bicepVirtualNetwork.bicep
// Parameters
@allowed([
  'new'
  'existing'
])
param vNetNewOrExisting string

param vNetName string
param vNetAddressPrefix string
param subnetInfo object

// Resources
resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = if (vNetNewOrExisting == 'new') {
  name: vNetName
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vNetAddressPrefix
      ]
    }
  }
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' = {
  parent: vnet
  name: subnetInfo.name
  properties: {
    addressPrefix: subnetInfo.addressPrefix
  }
}

//outputs
output subnetId string = subnet.id
