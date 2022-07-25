//모듈화 적용하지 않은 통합 bicep 파일
param name string
param location string = resourceGroup().location
param loc string = 'krc'
param publisherName string
param publisherEmail string
var rg = 'rg-${name}-${loc}'
var fncappname = 'fncapp-${name}-${loc}'

resource st 'Microsoft.Storage/storageAccounts@2021-09-01'={
  name:'st${name}'
  location:location
  sku:{
    name:'Standard_LRS'
  }
  kind:'StorageV2'
}

resource workspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: 'workspace-${name}-${loc}'
  location: location
  properties: {
      sku: {
          name: 'PerGB2018'
      }
      retentionInDays: 30
      workspaceCapping: {
          dailyQuotaGb: -1
      }
      publicNetworkAccessForIngestion: 'Enabled'
      publicNetworkAccessForQuery: 'Enabled'
  }
}

resource appins 'Microsoft.Insights/components@2020-02-02' = {
  name: 'appins-${name}-${loc}'
  location: location
  kind: 'web'
  properties: {
      Application_Type: 'web'
      Flow_Type: 'Bluefield'
      IngestionMode: 'LogAnalytics'
      Request_Source: 'rest'
      WorkspaceResourceId: workspace.id
  }
}

resource apim 'Microsoft.ApiManagement/service@2021-08-01' = {
  name: 'api-${name}-${loc}'
  location: location
  sku: {
      name: 'Consumption'
      capacity:0
  }
  properties: {
      publisherName: publisherName
      publisherEmail: publisherEmail
  }
}

resource csplan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name : 'csplan-${name}${loc}'
  location : location
  kind: 'functionapp'
  sku:{
    name : 'Y1'
    tier: 'Dynamic'
    size: 'Y1'
    family: 'Y'
    capacity: 0
  }
  properties:{
    reserved: true
  }
}

resource fncapp 'Microsoft.Web/sites@2021-03-01' = {
  name : fncappname
  location: location
  kind: 'functionapp'
  properties: {
    serverFarmId: csplan.id //앱서비스 플랜 종속
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsSecretStorageType' //저장소 종속
          value: st.id
        }
      ]
    }
  }
}

output rn string = rg
