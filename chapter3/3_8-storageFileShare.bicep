//3_8-storageFileShare.bicep
resource bicepstgacct 'Microsoft.Storage/storageAccounts@2021-02-01' existing = {
  name: 'bicepstgacct'
}

resource bicepfile 'Microsoft.Storage/storageAccounts/fileServices@2021-02-01' existing = {
  name: 'default'
  parent: bicepstgacct
}

resource share 'Microsoft.Storage/storageAccounts/fileServices/shares@2021-02-01' = {
  name: 'bicepshare'
  parent: bicepfile
  properties: {
    enabledProtocols: 'SMB'
    shareQuota: 10
  }
}
