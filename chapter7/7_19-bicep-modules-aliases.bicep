//7_19-bicep-modules-aliases.bicep
// Parameters
param vmName string = 'ubuntu01'
param vmSize string = 'Standard_B2s'
param osDiskType string = 'Standard_LRS'
param rgLocation string = resourceGroup().location

param osImage object = {
  sku: '18.04-LTS'
  version: 'latest'
  publisher: 'Canonical'
  offer: 'UbuntuServer'
}

param vNetInfo object = {
  name: 'bicepVNet'
  vNetnewOrExisting: 'new'
  addressPrefix: '10.0.0.0/16'
  subnetInfo: {
    name: 'app'
    addressPrefix: '10.0.1.0/27'
  }
}

param adminUsername string = 'bicepuser'

@secure()
param adminPassword string

// Modules
module vnet 'modules/7_1-bicepVirtualNetwork.bicep' = {
  name: vNetInfo.name
  params: {
    vNetNewOrExisting: vNetInfo.vNetnewOrExisting
    vNetName: vNetInfo.name
    subnetInfo: vNetInfo.subnetInfo
    vNetAddressPrefix: vNetInfo.addressPrefix
    rgLocation: rgLocation
  }
}

module nsg 'ts/tspec:nsg:1.0.0' = {
  name: '${vmName}nsg'
  params: {
    nsgPrefix: vmName
    nsgProperties: [
      {
        name: 'SSH'
        priority: 1001
        protocol: 'tcp'
        access: 'allow'
        direction: 'inbound'
        destinationPortRange: 22 
      }
    ]
  }
}

module pip 'ts/tspec:pip:1.0.0' = {
  name: '${vmName}pip'
  params: {
    vmName: vmName
  }
}

module nic 'br/breg:nic:v1' = {
  name: '${vmName}nic'
  params: {
    netInterfacePrefix: vmName
    nsgId: nsg.outputs.id
    publicIPId: pip.outputs.pipInfo.id
    subnetId: vnet.outputs.subnetId
  }
}

// Resources
resource vm 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: vmName
  location: rgLocation
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
        publisher: osImage.publisher
        offer: osImage.offer
        sku: osImage.sku
        version: osImage.version
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.outputs.id
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

// Variables
var vmDnsFqdn = pip.outputs.pipInfo.dnsFqdn

// Outputs
output vmAccess object = {
  'adminUsername': adminUsername
  'vmDnsFqdn': vmDnsFqdn
  'connectCommand': 'ssh ${adminUsername}@${vmDnsFqdn}'
}
