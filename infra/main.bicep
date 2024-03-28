@description('Specifies the location for resources.')
param location string = resourceGroup().location

// create gallery
resource gallery 'Microsoft.Compute/galleries@2023-07-03' = {
  name: 'my_application_gallery'
  location: location
  properties: {
    description: 'vm applications gallery'
    identifier: {}
    sharingProfile: {
      permissions: 'Private'
    }
  }
}
