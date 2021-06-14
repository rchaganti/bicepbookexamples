@description('Specify a name for the static web app.')
param staticSiteName string = 'bicepDemo'

@description('Specify the tier for the static web app. Valid values are Free and Standard.')
@allowed([
  'Free'
  'Standard'
])
param skuTier string = 'Free'

@description('Specify a SKU name or code. The default value is same as skuTier.')
param skuName string = skuTier

@description('Specify the location where this resource needs to be created.')
@allowed([
  'westus2'
  'centralus'
  'eastus2'
  'westeurope'
  'eastasia'
])
param location string = 'centralus'

@secure()
param repoToken string

param webapp object = {
  github: {
    url: 'https://github.com/rchaganti/bicepbookexamples'
    branch: 'main'
  }

  build: {
    appLocation: '/chapter4/staticweb'
    apiLocation: ''
    artifactLocation: 'public'
  }
}

resource bicepDemo 'Microsoft.Web/staticSites@2021-01-01' = {
  name: staticSiteName
  location: location
  sku: {
    tier: skuTier
    name: skuName
  }
  properties: {
    repositoryUrl: webapp.github.url
    repositoryToken: repoToken
    branch: webapp.github.branch
    buildProperties: {
      appLocation: webapp.build.appLocation
      apiLocation: webapp.build.apiLocation
      appArtifactLocation: webapp.build.artifactLocation
    }
  }
}
