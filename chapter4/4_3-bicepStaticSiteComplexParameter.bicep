//4_3-bicepStaticSiteComplexParameter.bicep
// Parameters section
param staticSiteName string = 'bicepDemo'
param skuName string = 'Free'
param skuTier string = 'Free'
param location string = 'centralus'

/*
This parameter is an object.
  webapp.github.url is the GitHub repository for the static app
  webapp.github.branch is the repository branch where you have ths static web app content
  webapp.build.appLocation is the folder where you have the static web app content
  webapp.build.apiLocation is the API location for the static web app
  webapp.build.artifactLocation is the artifact location for generated static site
*/
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

// Resource section
resource bicepDemo 'Microsoft.Web/staticSites@2021-01-01' = {
  name: staticSiteName
  location: location
  sku: {
    tier: skuTier
    name: skuName
  }
  properties: {
    repositoryUrl: webapp.github.url
    repositoryToken: 'GITHUB_TOKEN'
    branch: webapp.github.branch
    buildProperties: {
      appLocation: webapp.build.appLocation
      apiLocation: webapp.build.apiLocation
      appArtifactLocation: webapp.build.artifactLocation
    }
  }
}
