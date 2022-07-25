param name string
param location string = resourceGroup().location
param loc string = 'krc'

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

var stKind='StorageV2'



resource st 'Microsoft.Storage/storageAccounts@2021-09-01'={
  name : 'st${name}${loc}'
  location:location
  kind: stKind
  sku:{
    name: storageAccountSku
  }
  properties:{
    supportsHttpsTrafficOnly:true
  }

  }

output id string = st.id
output name string = st.name
