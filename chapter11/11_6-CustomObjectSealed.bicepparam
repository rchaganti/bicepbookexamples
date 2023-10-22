using './11_6-CustomObjectSealed.bicep'

param vmConfig = {
  name: 'vm01'
  location: 'eastus'
  size: 'Large'
  adminUser: 'ubuntuaaaa'
  adminPassword: 'T3stTh1S'
  randomProperty: 'Test'
}

