//5_1-bicepStaticSiteParamAndVar.bicep
// Parameters section
@secure()
param repoToken string // This is the GitHub Personal Access Token

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

// Variables section 1
var staticSiteName = 'bicepdemo'
var skuTier = 'Free'
var skuName = skuTier
var location = resourceGroup().location

// Resources section
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

// Variables section 2
var defaultHostname = bicepDemo.properties.defaultHostname

// Output section
output staticSiteHotsName string = defaultHostname
