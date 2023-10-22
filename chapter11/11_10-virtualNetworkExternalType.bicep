// 11_10-virtualNetworkExternalType.bicep

import * as vnetType from '11_9-customTypes.bicep'

// parameters
@allowed([
  'new'
  'existing'
])
param vNetNewOrExisting string

param vNetName string
param vNetAddressPrefix string
param rgLocation string = resourceGroup().location
param subnetInfo vnetType.subnetType

// Resources
resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = if (vNetNewOrExisting == 'new') {
  name: vNetName
  location: rgLocation
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
