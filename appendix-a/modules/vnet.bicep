// Name        : vnet.bicep
// Description : Creates a virtual network
// Version     : 1.0.0
// Author      : github.com/rchaganti

// parameters
@description('Create a new virtual network or use an existing one.')
@allowed([
  'new'
  'existing'
])
param newOrExisting string = 'new'

@description('Name of the virtual network to create.')
param vNetName string

@description('Location of the virtual network.')
param location string

@description('Virtual network address prefix.')
param vNetAddressPrefix string

@description('Virtual network address prefix.')
param subnetName string

@description('Subnet address prefix.')
param subnetPrefix string

// resources
resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = if (newOrExisting == 'new') {
  name: vNetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vNetAddressPrefix
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetPrefix
        }
      }
    ]
  }

  resource subnet 'subnets' existing = {
    name: subnetName
  }
}

// outputs
output subnetId string = vnet::subnet.id
