// 7_2-bicepNetworkSecurityGroup.bicep
// Parameters
param nsgPrefix string
param nsgProperties array

// Resources
resource nsg 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: '${nsgPrefix}-nsg'
  location: resourceGroup().location
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

// Outputs
output id string = nsg.id
