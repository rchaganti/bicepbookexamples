// Name        : nsg.bicep
// Description : Creates a network security group
// Version     : 1.0.0
// Author      : github.com/rchaganti

// parameters
param nsgName string
param nsgProperties array
param location string

// resources
resource nsg 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: [for nsg in nsgProperties: {
        name: nsg.name
        properties: {
          priority: nsg.priority
          protocol: nsg.protocol
          access: nsg.access
          direction: nsg.direction
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: nsg.destinationPortRange
        }        
      }]
  }
}

// outputs
output id string = nsg.id
