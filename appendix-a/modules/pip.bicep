// Name        : pip.bicep
// Description : Creates a public IP address
// Version     : 1.0.0
// Author      : github.com/rchaganti

// parameters
param vmName string
param location string

// variables
var pipName = '${vmName}pip'

// resources
resource pip 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name: '${vmName}pip'
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    publicIPAddressVersion: 'IPv4'
    dnsSettings: {
      domainNameLabel: '${vmName}${uniqueString(resourceGroup().id)}'
    }
    idleTimeoutInMinutes: 10
  }
}

// variables
var pipIP = reference(resourceId('Microsoft.Network/publicIPAddresses', pipName), '2021-02-01', 'full').properties

// outputs
output pipInfo object = {
  id: pip.id
  dnsFqdn: pipIP.dnsSettings.fqdn
}
