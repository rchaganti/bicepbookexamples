// 7_4-bicepNetworkInterfaces.bicep
// Parameters
param subnetId string
param publicIPId string
param nsgId string
param netInterfacePrefix string

// Resources
resource nic 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: '${netInterfacePrefix}-nic'
  location: resourceGroup().location
  properties: {
    ipConfigurations: [
      {
        name: '${netInterfacePrefix}-nicConfig'

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

// Outputs
output id string = nic.id
