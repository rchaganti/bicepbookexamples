param netInterfacePrefix string = 'bicep'
param publicIPPrefix string = 'bicep'

param vmName string = 'ubuntu20-01'
param adminUsername string = 'bicepuser'

@description('Specify if you want to use password or sshkey for authentication')
@allowed([
  'password'
  'sshkey'
])
param passwordOrSshKeyForAuthentication string = 'sshkey'

@description('Specify a password or ssh-key based on your authentication choice')
@secure()
param adminPasswordOrKey string

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
      adminPassword: adminPasswordOrKey
      linuxConfiguration: any(passwordOrSshKeyForAuthentication == 'sshkey' ? {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              path: '/home/${adminUsername}/.ssh/authorized_keys'
              keyData: adminPasswordOrKey
            }
          ]
        }
      } : null)
    }
  }
}

var pipIP = reference(resourceId('Microsoft.Network/publicIPAddresses', publicIPName), '2021-02-01', 'full').properties

output vmAccess object = {
  'adminUsername': adminUsername
  'vmDnsFqdn': pipIP.dnsSettings.fqdn
  'connectCommand': 'ssh ${adminUsername}@${pipIP.dnsSettings.fqdn}'
}
