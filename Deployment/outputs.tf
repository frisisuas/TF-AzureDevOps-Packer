
output "storage-account" {
  value = azurerm_storage_account.stg_acc.name
}

output "storage-fileshare" {
  value = azurerm_storage_share.strg_share
}
output "strg-acct-primary-key" {
  value     = azurerm_storage_account.stg_acc.primary_access_key
  sensitive = true
}
output "strg-acct-secondary-key" {
  value     = azurerm_storage_account.stg_acc.secondary_access_key
  sensitive = true
}

output "service-principal" {
  value = azuread_service_principal.tf_sp.display_name
}
output "sp_appid" {
  value = azuread_service_principal.tf_sp.application_id
}
output "sp_password" {
  value     = azuread_service_principal_password.tf_sp_pass.value
  sensitive = true
}
output "tenantID" {
  value     = data.azurerm_client_config.user_extract.tenant_id
  sensitive = true
}