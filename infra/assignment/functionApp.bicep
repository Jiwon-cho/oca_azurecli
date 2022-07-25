param name string
param location string = resourceGroup().location
param loc string = 'krc'
param storageAccountId string
param storageAccountName string
param appInsightsId string
param consumptionPlanId string
var fncappname = 'fncapp-${name}-${loc}'
var kind='functionapp'

resource fncapp 'Microsoft.Web/sites@2021-03-01' = {
  name : fncappname
  location: location
  kind: kind
  properties: {
    serverFarmId: consumptionPlanId //앱서비스 플랜 종속
    siteConfig: {
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: '${reference(appInsightsId, '2020-02-02', 'Full').properties.InstrumentationKey}'
      }
      {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: '${reference(appInsightsId, '2020-02-02', 'Full').properties.connectionString}'
      }
        {
          name: 'AzureWebJobsSecretStorage' //저장소 종속
          value: storageAccountId
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccountId, '2021-06-01').keys[0].value}'
      }
      ]
    }
  }
}
output id string = fncapp.id
output name string = fncapp.name
