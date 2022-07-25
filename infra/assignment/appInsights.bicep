param name string
param location string = resourceGroup().location
param loc string = 'krc'
param workspaceId string

@allowed([
  'web'
  'other'
])
param appInsightsType string = 'web'

@allowed([
  'ApplicationInsights'
  'ApplicationInsightsWithDiagnosticSettings'
  'LogAnalytics'
])
param appInsightsIngestionMode string = 'LogAnalytics'


resource appins 'Microsoft.Insights/components@2020-02-02' = {
  name: 'appins-${name}-${loc}'
  location: location
  kind: 'web'
  properties: {
      Application_Type: appInsightsType
      Flow_Type: 'Bluefield'
      IngestionMode: appInsightsIngestionMode
      Request_Source: 'rest'
      WorkspaceResourceId: workspaceId
  }
}

output id string = appins.id
output name string = appins.name
output instrumentationKey string = appins.properties.InstrumentationKey
