param location string
param appName string

// App Service Plan
resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: '${appName}-plan'
  location: location
  sku: {
    name: 'P1v3'          // Change from 'P0v3' to 'P1v3'
    tier: 'PremiumV3'
    size: 'P1v3'
  }
  properties: {
    reserved: true // For Linux-based hosting
  }
}

// Web App
resource webApp 'Microsoft.Web/sites@2021-02-01' = {
  name: appName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|8.0'
      appSettings: [
        {
          name: 'WEBSITE_RUN_FROM_PACKAGE'
          value: '1'
        }
      ]
    }
  }
}

// Deployment Slot - dev
resource devSlot 'Microsoft.Web/sites/slots@2021-02-01' = {
  name: 'dev'
  parent: webApp
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|8.0'
    }
  }
}

// Deployment Slot - staging
resource stagingSlot 'Microsoft.Web/sites/slots@2021-02-01' = {
  name: 'staging'
  parent: webApp
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|8.0'
    }
  }
}

// Deployment Slot - prod
resource prodSlot 'Microsoft.Web/sites/slots@2021-02-01' = {
  name: 'prod'
  parent: webApp
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|8.0'
    }
  }
}
