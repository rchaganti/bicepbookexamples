param netInterfacePrefix string = 'bicep'
param publicIPPrefix string = 'bicep'

param vmName string = 'ubuntu20-01'
param adminUsername string = 'bicepuser'

@secure()
param adminPassword string

var location = resourceGroup().location

var nicName = '${netInterfacePrefix}${vmName}-nic'
var publicIPName = '${publicIPPrefix}${vmName}-pip'

var osVersion = '18.04-LTS'
var vmSize = 'Standard_B2s'
var osDiskType = 'Standard_LRS'

resource vm 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: osDiskType
        }
      }
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: osVersion
        version: 'latest'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: resourceId('Microsoft.Network/networkInterfaces', nicName)
        }
      ]
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
  }
}

var pipIP = reference(resourceId('Microsoft.Network/publicIPAddresses', publicIPName), '2021-02-01', 'full').properties

output vmAccess object = {
  'adminUsername': adminUsername
  'vmDnsFqdn': pipIP.dnsSettings.fqdn
  'connectCommand': 'ssh ${adminUsername}@${pipIP.dnsSettings.fqdn}'
}
