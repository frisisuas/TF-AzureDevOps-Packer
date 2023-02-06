resource "azuredevops_variable_group" "vars" {
  project_id   = azuredevops_project.test_project.id
  name         = "packer-image-build-variables"
  allow_access = true
  variable {
    name  = "ImageDestRG"
    value = var.rgname
  }

  variable {
    name  = "Location"
    value = var.location
  }

  variable {
    name  = "StorageAccountInstallerPath"
    value = "\\\\packerinstapps${random_string.randomize.result}.blob.core.windows.net\\installers"
  }

  variable {
    name  = "VirtualNetwork"
    value = azurerm_virtual_network.vnet.name
  }

  variable {
    name  = "VirtualNetworkRG"
    value = var.rgname
  }

  variable {
    name  = "Subnet"
    value = azurerm_subnet.subnet.name
  }

  variable {
    name  = "VMSize"
    value = "Standard_DS3_v2"
  }

  variable {
    name  = "SubscriptionID"
    value = var.scope_id
  }

  variable {
    name  = "TenantID"
    value = var.azurerm_spn_tenant_id
  }

  variable {
    name  = "TempResourceGroup"
    value = "packer-build-images"
  }
}


resource "azuredevops_variable_group" "key_vars" {
  depends_on = [
    azurerm_key_vault_secret.StorageAccountKey,
    azurerm_key_vault_secret.StorageAccountName,
    azurerm_key_vault_secret.ADOAppSecret,
    azurerm_key_vault_secret.ADOAppID
  ]
  name         = "keyvault-image-build-variables"
  project_id   = azuredevops_project.test_project.id
  allow_access = true

  key_vault {
    name                = azurerm_key_vault.key_vault.name
    service_endpoint_id = azuredevops_serviceendpoint_azurerm.endpoint_connection_sp.id
  }
  variable {
    name = "ADOAppID"
  }
  variable {
    name = "ADOAppSecret"
  }
  variable {
    name = "StorageAccountName"
  }
  variable {
    name = "StorageAccountKey"
  }
}

