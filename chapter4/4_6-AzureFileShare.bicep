param shareName string = 'bicepshare'

@minLength(3)
@maxLength(24)
param storageAccountName string = 'bicepstgacct'

@minValue(2)
@maxValue(10)
param shareQuota int = 4

resource bicepstgacct 'Microsoft.Storage/storageAccounts@2021-02-01' existing = {
  name: storageAccountName
}

resource bicepfile 'Microsoft.Storage/storageAccounts/fileServices@2021-02-01' existing = {
  name: 'default'
  parent: bicepstgacct
}

resource share 'Microsoft.Storage/storageAccounts/fileServices/shares@2021-02-01' = {
  name: shareName
  parent: bicepfile
  properties: {
    enabledProtocols: 'SMB'
    shareQuota: shareQuota
  }
}

output fileShare string = share.id
