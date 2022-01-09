//7_6-bicepVirtualMachines.bicep
// Parameters
param virtualMachines array = [
  {
    vmName: 'ubuntu-01'
    vmSize: 'Standard_B2s'
    osDiskType: 'Standard_LRS'
    osImage: {
      sku: '18.04-LTS'
      version: 'latest'
      publisher: 'Canonical'
      offer: 'UbuntuServer'
    }
    vNet: {
      name: 'bicepVNet'
      vNetNewOrExisting: 'new'
      addressPrefix: '10.0.0.0/16'
      subnetInfo: {
        name: 'db'
        addressPrefix: '10.0.1.0/27'
      }
    }
  }
  {
    vmName: 'ubuntu-02'
    vmSize: 'Standard_B2s'
    osDiskType: 'Standard_LRS'
    osImage: {
      sku: '18.04-LTS'
      version: 'latest'
      publisher: 'Canonical'
      offer: 'UbuntuServer'
    }
    vNet: {
      name: 'bicepVNet'
      vNetNewOrExisting: 'existing'
      addressPrefix: '10.0.0.0/16'
      subnetInfo: {
        name: 'app'
        addressPrefix: '10.0.2.0/27'
      }
    }
  }
]

param adminUsername string = 'bicepuser'

@secure()
param adminPassword string

@batchSize(1)
module vms '7_5-bicepVirtualMachine.bicep' = [for item in virtualMachines: {
  name: item.vmName
  params: {
    vmName: item.vmName
    vmSize: item.vmSize
    osDiskType: item.osDiskType 
    osImage: item.osImage
    adminUsername: adminUsername
    adminPassword: adminPassword
    vNetInfo: item.vNet
  }
}]

