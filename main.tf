####
# Necesitamos un resource group para poder desplegar
# los recursos básicos para poder desplegar los recursos mediante packer.
####
resource "azurerm_resource_group" "rg" {
  name     = var.rgname
  location = var.location
}

## Obtendremos los datos del usuario conectado:
data "azurerm_client_config" "user_extract" {
}


# Creación de un Storage Account
resource "azurerm_storage_account" "stg_acc" {
  account_replication_type  = "LRS"
  account_tier              = "Standard"
  location                  = var.location
  name                      = "packerinstapps${random_string.randomize.result}"
  resource_group_name       = azurerm_resource_group.rg.name
  access_tier               = "Hot"
  account_kind              = "StorageV2"
  enable_https_traffic_only = true
  allow_blob_public_access  = false

}

# Necesitamos un file share donde poner los instaladores del software para la imagen.
resource "azurerm_storage_share" "strg_share" {
  depends_on = [
    azurerm_storage_account.stg_acc
  ]
  name                 = "installers"
  storage_account_name = azurerm_storage_account.stg_acc.name
  quota                = 2

}
