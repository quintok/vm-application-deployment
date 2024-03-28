@description('Specifies the location for resources.')
param location string = resourceGroup().location

param mediaLink string

// create gallery
resource gallery 'Microsoft.Compute/galleries@2023-07-03' = {
  name: 'my_application_gallery'
  location: location
  properties: {
    description: 'vm applications gallery'
  }
}

resource app 'Microsoft.Compute/galleries/applications@2023-07-03' = {
  name: 'Firefox'
  location: location
  parent: gallery
  properties: {
    supportedOSType: 'Windows'
  }
}

resource appVersion 'Microsoft.Compute/galleries/applications/versions@2023-07-03' = {
  name: '124.0.1'
  location: location
  parent: app
  properties: {
    publishingProfile: {
      source: {
        mediaLink: mediaLink
      }
      manageActions: {
        install: 'msiexec.exe /i "Firefox" INSTALL_DIRECTORY_PATH="C:\\Firefox\\" TASKBAR_SHORTCUT=false DESKTOP_SHORTCUT=false INSTALL_MAINTENANCE_SERVICE=false /quiet'
        remove: 'C:\\Firefox\\uninstall\\helper.exe /S /uninstall'
      }
      targetRegions: [
        {
          name: location
          regionalReplicaCount: 1
          storageAccountType: 'Standard_LRS'
        }
      ]
      replicaCount: 1
    }
  }
}
