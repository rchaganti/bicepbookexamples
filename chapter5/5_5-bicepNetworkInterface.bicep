//5_5-bicepNetworkInterface.bicep
param vmName string = 'ubuntu20-01'
param vNetPrefix string = 'bicep'
param subnetPrefix string = 'bicep'
param publicIPPrefix string = 'bicep'
param nsgPrefix string = 'bicep'
param netInterfacePrefix string = 'bicep'

var publicIPName = '${publicIPPrefix}${vmName}-pip'
var location = resourceGroup().location
var nicName = '${netInterfacePrefix}${vmName}-nic'
var nicIpConfigName = '${nicName}-ipconfig'

resource nic 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: nicIpConfigName

        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', '${vNetPrefix}-Net','${subnetPrefix}-subnet1')
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: resourceId('Microsoft.Network/publicIPAddresses', publicIPName)
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: resourceId('Microsoft.Network/networkSecurityGroups', '${nsgPrefix}-nsg')
    }
  }
}
