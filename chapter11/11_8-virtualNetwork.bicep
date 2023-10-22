// 11_8-virtualNetwork.bicep
// custom types
@sealed()
type subnetType = {
  name: string
  addressPrefix: string
}

// parameters
@allowed([
  'new'
  'existing'
])
param vNetNewOrExisting string

param vNetName string
param vNetAddressPrefix string
param rgLocation string = resourceGroup().location
param subnetInfo subnetType

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
