// Name        : nic.bicep
// Description : Creates a network interface
// Version     : 1.0.0
// Author      : github.com/rchaganti

// parameters
@description('Prefix for creating unique names for the network interface.')
param netInterfacePrefix string

@description('Subnet ID to which the adapter needs to be attached.')
param subnetId string

@description('Resource Id of the public IP that will be associated with the network interface.')
param publicIPId string

@description('Resource Id of the network security group that will be associated with the network interface.')
param nsgId string

@description('Location at which this network interface will provisioned.')
param location string

// resources
resource nic 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: '${netInterfacePrefix}nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: '${netInterfacePrefix}nicConfig'

        properties: {
          subnet: {
            id: subnetId
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPId
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: nsgId
    }
  }
}

// outputs
output id string = nic.id
