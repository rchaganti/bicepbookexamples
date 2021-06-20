param nsgPrefix string = 'bicep'

var location = resourceGroup().location
var nsgProperties = [
  {
    name: 'SSH'
    priority: 1001
    protocol: 'Tcp'
    destinationPortRange: '22'
  }
  {
    name: 'HTTP'
    priority: 1002
    protocol: 'Tcp'
    destinationPortRange: '80'
  }
]

resource nsg 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: '${nsgPrefix}-nsg'
  location: location
  properties: {
    securityRules: [
      {
        name: nsgProperties[0].name
        properties: {
          priority: nsgProperties[0].priority
          protocol: nsgProperties[0].protocol
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: nsgProperties[0].destinationPortRange
        }        
      }
      {
        name: nsgProperties[1].name
        properties: {
          priority: nsgProperties[1].priority
          protocol: nsgProperties[1].protocol
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: nsgProperties[1].destinationPortRange
        }        
      }      
    ]
  }
}
