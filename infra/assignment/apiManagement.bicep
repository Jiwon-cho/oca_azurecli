param name string
param location string = resourceGroup().location
param loc string = 'krc'
param publisherName string
param publisherEmail string
param apiManagementSkuCapacity int = 0
@allowed([
  'Consumption'
  'Isolated'
  'Developer'
  'Basic'
  'Standard'
  'Premium'
])
param apiManagementSkuName string = 'Consumption'


resource apim 'Microsoft.ApiManagement/service@2021-08-01' = {
  name: 'apim-${name}-${loc}'
  location: location
  sku: {
      name: apiManagementSkuName
      capacity:apiManagementSkuCapacity
  }
  properties: {
      publisherName: publisherName
      publisherEmail: publisherEmail
  }
}
