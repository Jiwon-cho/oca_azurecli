param name string
param location string = resourceGroup().location
param loc string = 'krc'

var rg = 'rg-${name}-${loc}' //rg-oca-krc
var fncappname = 'fncapp-${name}-${loc}'//rg-oca-krc

resource st 'Microsoft.Storage/storageAccounts@2021-09-01'={
  name : 'st${name}${loc}'
  location:location
  kind: 'StorageV2'
  sku:{
    name: 'Standard_LRS'
  }
  properties:{
    supportsHttpsTrafficOnly:true
  }

  }

resource csplan 'Microsoft.Web/serverfarms@2022-03-01' ={
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
  name:fncappname
  location: location
  kind: 'functionapp'
  properties:{
    serverFarmId:csplan.id
    siteConfig:{
      appSettings:[
        {
          name: 'AzureWebJobStorage'
          value: 'id:${st.id}'
        }
      ]
    }
  }
}
//servicefamid 를 통해서 plan id 가져오고
//appsetting를 통해서 storage id 가져오기


// resource appsvc2 'Microsoft.Web/sites@2022-03-01' = {

// }

output rn string = rg
