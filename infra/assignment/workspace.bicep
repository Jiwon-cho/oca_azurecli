param name string
param location string = resourceGroup().location
param loc string = 'krc'

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

resource workspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: 'workspace-${name}-${loc}'
  location: location
  properties: {
      sku: {
          name: workspaceSku
      }
      retentionInDays: 30
      workspaceCapping: {
          dailyQuotaGb: -1
      }
      publicNetworkAccessForIngestion: 'Enabled'
      publicNetworkAccessForQuery: 'Enabled'
  }
}

output id string = workspace.id
output name string = workspace.name
