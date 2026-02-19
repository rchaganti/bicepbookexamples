// Name        : storage.bicep
// Description : Creates storage account, container, and fileshare
// Version     : 1.0.0
// Author      : github.com/rchaganti

// parameters
@description('Name for the storage account. This has to be globally unique.')
param storageAccountName string

@description('Name for the file share.')
param storageFileShareName string

@description('Location where this storage account needs to be created.')
param location string

// resources
resource sa 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    accessTier: 'Cool'
  }
}

resource fileShare 'Microsoft.Storage/storageAccounts/fileServices/shares@2023-05-01' = {
  name: '${sa.name}/default/${storageFileShareName}'
}

// outputs
output storage object = {
  name: storageAccountName
  shareUri: '//${storageAccountName}.file.${environment().suffixes.storage}/${storageFileShareName}'
}

// Output storage account resource ID for parent template to retrieve keys securely
output storageAccountId string = sa.id
