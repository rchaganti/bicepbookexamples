// 10_1-anyFunction.bicep
@description('Specify a name for the NIC')
param nicName string

@description('Specify a location where this NIC resource needs to be created; default is resource group location.')
param location string = resourceGroup().location

@description('Specify a subnet ID')
param subnetId string

@description('specify a Public IP address ID')
param pipId string = ''

@description('Specify the IP allocation method; default is Dynamic')
@allowed([
  'Dynamic'
  'Static'
])
param ipAllocationMethod string = 'Dynamic'

@description('Specify the static IP address; this becomes optional when ipAllocationMethod is set to Dynamic')
param staticIpAddress string = ''

@description('Specify if IP forwarding should be enabled; default is false')
param enableIPForwarding bool = false

resource nicResource 'Microsoft.Network/networkInterfaces@2020-06-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig'
        properties: {
          primary: true
          privateIPAllocationMethod: ipAllocationMethod
          privateIPAddress: staticIpAddress
          subnet: {
            id: subnetId
          }
          publicIPAddress: any((pipId == '') ? null : {
            id: pipId
          })
        }
      }
    ]
    enableIPForwarding: enableIPForwarding
  }
}

output nicId string = nicResource.id
output privateIP string = nicResource.properties.ipConfigurations[0].properties.privateIPAddress
