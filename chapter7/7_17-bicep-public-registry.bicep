module samplevNet 'br/public:network/virtual-network:1.0.1' = {
  name: '${uniqueString(deployment().name, 'EastUS')}-vnet'
  params: {
    name: 'vnet-bicep-sample'
    addressPrefixes: [
      '10.0.0.0/24'
    ]
  }
}
