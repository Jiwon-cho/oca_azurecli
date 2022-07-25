param name string
param location string = resourceGroup().location
param loc string = 'krc'
param consumptionPlanIsLinux bool = false

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
    reserved: consumptionPlanIsLinux
  }
}

output id string = csplan.id
