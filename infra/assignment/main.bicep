param name string
param location string = resourceGroup().location
param loc string = 'krc'
param publisherName string
param publisherEmail string
param apiManagementSkuCapacity int = 0

@allowed([
  'Standard_LRS'
  'Standard_ZRS'    
  'Standard_GRS'
  'Standard_GZRS'
  'Standard_RAGRS'
  'Standard_RAGZRS'
  'Premium_LRS'
  'Premium_ZRS'
])
param storageAccountSku string = 'Standard_LRS'

@allowed([
  'Free'
  'Standard'
  'Premium'
  'Standalone'
  'LACluster'
  'PerGB2018'
  'PerNode'
  'CapacityReservation'
])
param workspaceSku string = 'PerGB2018'

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

@allowed([
  'Consumption'
  'Isolated'
  'Developer'
  'Basic'
  'Standard'
  'Premium'
])
param apiManagementSkuName string = 'Consumption'

// Consumption Plan
param consumptionPlanIsLinux bool = false

var rg = 'rg-${name}-${loc}'


module storageAccount './storageAccount.bicep' = {
  name: 'storageAccount${name}${loc}'
  params: {
      name: name
      location: location
      storageAccountSku: storageAccountSku
      loc: loc
  }
}

module workspace './workspace.bicep' = {
  name: 'workspace-${name}-${loc}'
  params: {
      name: name
      location: location
      workspaceSku: workspaceSku
      loc: loc
  }
}

module apiManagement './apiManagement.bicep' = {
  name: 'appiManagement-${name}-${loc}'
  params: {
      name: name
      apiManagementSkuName: apiManagementSkuName
      apiManagementSkuCapacity:apiManagementSkuCapacity
      location: location
      publisherEmail:  publisherEmail
      publisherName: publisherName
      loc: loc
  }
}

module appInsights './appInsights.bicep' = {
  name: 'appInsights-${name}-${loc}'
  params: {
      name: name
      location: location
      appInsightsType: appInsightsType
      appInsightsIngestionMode: appInsightsIngestionMode
      workspaceId: workspace.outputs.id
      loc: loc
  }
}

module consumptionPlan './consumptionPlan.bicep' = {
  name: 'consumptionPlan-${name}${loc}'
  params: {
      name: name
      location: location
      consumptionPlanIsLinux: consumptionPlanIsLinux
      loc: loc
  }
}


module functionApp './functionApp.bicep' = {
  name: 'functionApp-${name}${loc}'
  params: {
      name: name
      location: location
      loc:loc
      storageAccountId: storageAccount.outputs.id
      storageAccountName: storageAccount.outputs.name
      appInsightsId: appInsights.outputs.id
      consumptionPlanId: consumptionPlan.outputs.id

  }
}

output rn string = rg
