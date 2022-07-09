// 10_4-sql.bicep
param serverName string = uniqueString('sql', resourceGroup().id)
param sqlDBName string = 'mySQLDB'
param resLocation string = resourceGroup().location
param adminUserName string = 'sqladmin'

@secure()
param adminPassword string

resource sqlServer 'Microsoft.Sql/servers@2021-08-01-preview' = {
  name: serverName
  location: resLocation
  properties: {
    administratorLogin: adminUserName
    administratorLoginPassword: adminPassword
  }
}

resource sqlDB 'Microsoft.Sql/servers/databases@2021-08-01-preview' = {
  parent: sqlServer
  name: sqlDBName
  location: resLocation
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }
}
