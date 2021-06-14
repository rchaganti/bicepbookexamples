param staticSiteName string = 'bicepDemo'
param skuName string = 'Free'
param skuTier string = 'Free'
param location string = 'centralus'
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
    repositoryToken: 'ghp_4ShBH0ABUJN'
    branch: webapp.github.branch
    buildProperties: {
      appLocation: webapp.build.appLocation
      apiLocation: webapp.build.apiLocation
      appArtifactLocation: webapp.build.artifactLocation
    }
  }
}
