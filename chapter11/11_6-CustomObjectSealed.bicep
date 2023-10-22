// 11_6-CustomObjectSealed.bicep

@sealed()
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

param vmConfig vm

output vmObject object = {
  name: vmConfig.name
  location: vmConfig.location
  size: vmConfig.size
}
