//7_10-subscriptionScope.bicep
targetScope = 'subscription'

param subId string = '0d39bfe8-a1ab-4564-85c5-9db64bd97424'

module resGroup 'modules/resourceGroup.bicep' = {
  name: 'resGroup'
  scope: subscription(subId)
  params: {
    resGroupName: 'bicep'
    resGroupLocation: 'WestUS'
  }
}
