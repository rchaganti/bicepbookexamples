//4_1-bicepStaticSite.bicep
resource bicepDemo 'Microsoft.Web/staticSites@2021-01-01' = {
  name: 'bicepDemo'
  location: 'centralus'
  sku: {
    tier: 'Free'
    name: 'Free'
  }
  properties: {
    repositoryUrl: 'https://github.com/rchaganti/bicepbookexamples'
    repositoryToken: 'GITHUB_PAT'
    branch: 'main'
    buildProperties: {
      appLocation: '/chapter4/staticweb'
      apiLocation: ''
      appArtifactLocation: 'public'
    }
  }
}
