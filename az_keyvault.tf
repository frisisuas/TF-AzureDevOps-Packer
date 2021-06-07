resource "azurerm_key_vault" "key_vault" {
  depends_on = [
    azuread_service_principal.tf_sp
  ]
  name                       = "packer-secrets-${random_string.randomize.result}"
  location                   = var.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.user_extract.tenant_id
  soft_delete_retention_days = 7
  purge_protection_enabled   = false
  sku_name                   = "standard"

}

resource "azurerm_key_vault_access_policy" "kv_pol_admin" {
  depends_on = [
    azurerm_key_vault.key_vault
  ]
  key_vault_id = azurerm_key_vault.key_vault.id
  tenant_id    = data.azurerm_client_config.user_extract.tenant_id
  object_id    = data.azurerm_client_config.user_extract.object_id
  key_permissions = [
    "get", "list", "update", "create", "import", "delete", "recover", "backup", "restore", "purge"
  ]
  secret_permissions = [
    "get", "list", "delete", "recover", "backup", "restore", "set", "purge"
  ]
  certificate_permissions = [
    "get", "list", "update", "create", "import", "delete", "recover", "backup", "restore", "deleteissuers", "getissuers", "listissuers", "managecontacts", "manageissuers", "setissuers"
  ]
}

resource "azurerm_key_vault_access_policy" "kv_pol_sp" {
  depends_on = [
    azurerm_key_vault_access_policy.kv_pol_admin
  ]
  key_vault_id = azurerm_key_vault.key_vault.id
  tenant_id    = data.azurerm_client_config.user_extract.tenant_id
  object_id    = azuread_service_principal.tf_sp.object_id
  key_permissions = [
    "get", "list", "update", "create", "import", "delete", "recover", "backup", "restore", "purge"
  ]
  secret_permissions = [
    "get", "list", "delete", "recover", "backup", "restore", "set", "purge"
  ]
  certificate_permissions = [
    "get", "list", "update", "create", "import", "delete", "recover", "backup", "restore", "deleteissuers", "getissuers", "listissuers", "managecontacts", "manageissuers", "setissuers"
  ]
}

# Creación de los secretos para los pipelines:
resource "azurerm_key_vault_secret" "ADOAppID" {
  depends_on = [
    azurerm_key_vault_access_policy.kv_pol_sp
  ]
  key_vault_id = azurerm_key_vault.key_vault.id
  name         = "ADOAppID"
  value        = azuread_service_principal.tf_sp.application_id
}
resource "azurerm_key_vault_secret" "ADOAppSecret" {
    depends_on = [
    azurerm_key_vault_access_policy.kv_pol_sp
  ]
  key_vault_id = azurerm_key_vault.key_vault.id
  name         = "ADOAppSecret"
  value        = azuread_service_principal_password.tf_sp_pass.value
}
resource "azurerm_key_vault_secret" "StorageAccountName" {
    depends_on = [
    azurerm_key_vault_access_policy.kv_pol_sp
  ]
  key_vault_id = azurerm_key_vault.key_vault.id
  name         = "StorageAccountName"
  value        = azurerm_storage_account.stg_acc.name
}
resource "azurerm_key_vault_secret" "StorageAccountKey" {
    depends_on = [
    azurerm_key_vault_access_policy.kv_pol_sp
  ]
  key_vault_id = azurerm_key_vault.key_vault.id
  name         = "StorageAccountKey"
  value        = azurerm_storage_account.stg_acc.primary_access_key
}
