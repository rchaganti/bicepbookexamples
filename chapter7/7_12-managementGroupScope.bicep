//7_12-managementGroupScope.bicep
targetScope = 'managementGroup'

param mgmtGroupName string
param policyDefName string

module polDef 'modules/policyDef.bicep' = {
  name: 'policyDef'
  scope: managementGroup(mgmtGroupName)
  params: {
    policyDefinitionName: policyDefName
  }
}
