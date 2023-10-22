// 11_5-CustomObjectWithDecorators.bicep

@description('A vm object type')
type vm = {
  @description('Name of the VM')
  @minLength(3)
  @maxLength(10)
  name: string
  
  @description('Name of the user')
  @minLength(8)
  @maxLength(12)  
  adminUser: string
  
  @description('Password for the admin user')
  @secure()
  adminPassword: string

  @description('Location of the VM resource')
  location: string?

  @description('Size of the VM')
  size: 'ExtraSmall' | 'Small' | 'Medium' | 'Large'
}

param vmConfig vm = {
  name: 'vm01'
  location: 'eastus'
  size: 'Large'
  adminUser: 'ubuntuaaaa'
  adminPassword: 'T3stTh1S'
}

output vmObject object = {
  name: vmConfig.name
  location: vmConfig.location
  size: vmConfig.size
}
