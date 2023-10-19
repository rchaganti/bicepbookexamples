// Name        : linuxvm.bicep
// Description : Creates a Linux virtual machine
// Version     : 1.0.0
// Author      : github.com/rchaganti

// parameters
@description('Name of the VM to be created.')
param vmName string

@description('The size of the VM')
param vmSize string = 'Standard_B2s'

@description('Network interface resource Id.')
param nicId string

@description('Location for VM resource.')
param location string

@description('Username for the VM.')
param username string

@description('Linux OS version.')
param osVersion string

@description('Linux OS offer.')
param osOffer string

@description('Linux OS publisher')
param osPublisher string

@description('Disk type for OS disk')
param osDiskType string = 'Standard_LRS'

@description('Type of authentication to use on the Virtual Machine. SSH key is recommended.')
@allowed([
  'sshPublicKey'
  'password'
])
param authenticationType string = 'password'

@description('SSH Key or password for the Virtual Machine. SSH key is recommended.')
@secure()
param passwordOrKey string

// variables
var linuxConfiguration = {
  disablePasswordAuthentication: true
  ssh: {
    publicKeys: [
      {
        path: '/home/${username}/.ssh/authorized_keys'
        keyData: passwordOrKey
      }
    ]
  }
}

// resources
resource vm 'Microsoft.Compute/virtualMachines@2021-11-01' = {
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
        publisher: osPublisher
        offer: osOffer
        sku: osVersion
        version: 'latest'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nicId
        }
      ]
    }
    osProfile: {
      computerName: vmName
      adminUsername: username
      adminPassword: passwordOrKey
      linuxConfiguration: ((authenticationType == 'password') ? null : linuxConfiguration)
    }
  }
}

// outputs
output vmInfo object = {
  id: vm.id
  name: vm.name
}
