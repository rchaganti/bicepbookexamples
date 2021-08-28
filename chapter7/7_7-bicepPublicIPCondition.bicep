// 7_7-bicepPublicIPCondition.bicep
// Parameters
param vmName string

@allowed([
  'new'
  'existing'
])
param newOrExisting string = 'new'

// Resources
module pip 'modules/7_3-bicepPublicIp.bicep' = if (newOrExisting == 'new') {
  name: 'pip'
  params: {
    vmName: vmName
  }
}

// Outputs
output pipInfo object = {
  id: pip.outputs.pipInfo.id
  dnsFqdn: pip.outputs.pipInfo.dnsFqdn
}
