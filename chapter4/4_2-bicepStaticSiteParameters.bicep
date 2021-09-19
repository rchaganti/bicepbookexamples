//4_2-bicepStaticSiteParameters.bicep
param staticSiteName string = 'bicepDemo'
param skuName string = 'Free'
param skuTier string = 'Free'
param location string = 'centralus'
param repoUrl string = 'https://github.com/rchaganti/bicepbookexamples'
param repoBranch string = 'main'
param appLocation string = '/chapter4/staticweb'
param appArtifactLocation string = 'public'
param appApiLocation string = ''

resource bicepDemo 'Microsoft.Web/staticSites@2021-01-01' = {
  name: staticSiteName
  location: location
  sku: {
    tier: skuTier
    name: skuName
  }
  properties: {
    repositoryUrl: repoUrl
    repositoryToken: 'GITHUB_TOKEN'
    branch: repoBranch
    buildProperties: {
      appLocation: appApiLocation
      apiLocation: appLocation
      appArtifactLocation: appArtifactLocation
    }
  }
}
