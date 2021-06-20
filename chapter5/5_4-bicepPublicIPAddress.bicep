param vmName string = 'ubuntu20-01'
param publicIPPrefix string = 'bicep'

var location = resourceGroup().location
var dnsLabelPrefix = toLower('${vmName}${take(uniqueString(resourceGroup().id), 6)}')

resource publicIP 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name: '${publicIPPrefix}${vmName}-pip'
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    publicIPAddressVersion: 'IPv4'
    dnsSettings: {
      domainNameLabel: dnsLabelPrefix
    }
    idleTimeoutInMinutes: 10
  }
}
