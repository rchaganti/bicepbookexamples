// 11_3-customObjectType.bicep

@description('A vm object type')
type vm = {
  name: string
  location: string
  size: 'ExtraSmall' | 'Small' | 'Medium' | 'Large'
}

param vmConfig vm = {
  name: 'vm01'
  location: 'eastus'
  size: 'Large'
}

output vmObject object = {
  name: vmConfig.name
  location: vmConfig.location
  size: vmConfig.size
}
