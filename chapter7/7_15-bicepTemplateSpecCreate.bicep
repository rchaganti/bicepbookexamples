//7_15-bicepTemplateSpecCreate.bicep
var templateSpecName = 'nsg'
var templateSpecDisplayName = 'Azure Network Security Group'
var templateSpecVersion = '1.0.0'
var templateSpecDescription = 'Creates an Azure Network Security Group'
var templateSpecJson = loadTextContent('modules/7_2-bicepNetworkSecurityGroup.json')

var location = resourceGroup().location

resource templateSpecName_resource 'Microsoft.Resources/templateSpecs@2019-06-01-preview' = {
  name: templateSpecName
  location: location
  properties: {
    description: templateSpecDescription
    displayName: templateSpecDisplayName
  }
}

resource templateSpecName_templateSpecVersion 'Microsoft.Resources/templateSpecs/versions@2019-06-01-preview' = {
  name: '${templateSpecName_resource.name}/${templateSpecVersion}'
  location: location
  properties: {
    template: json(templateSpecJson)
  }
}

output templateSpecUri string = 'ts:${subscription().subscriptionId}/${resourceGroup().name}/${templateSpecName}:${templateSpecVersion}'
