resource "azuredevops_project" "test_project" {
  depends_on = [
    azuread_service_principal.tf_sp
  ]
  name               = "TF-AzureDevOps-Packer"
  description        = "Test para ver el funcionamiento mediante terraform"
  visibility         = "private"
  version_control    = "Git"
  work_item_template = "Basic"
  features = {
    "testplans" = "disabled"
    "artifacts" = "enabled"
  }
}

#creamos el repo
resource "azuredevops_git_repository" "repo" {
  project_id = azuredevops_project.test_project.id
  name       = "Repositorio para implementar packer y crear una golden image"

  initialization {
    init_type = "Clean"
  }
}

#Creación del endpoint para el SP
/*
    project_id – The ID for azure devops project, which will contain the endpoint
    service_endpoint_name – Name for service endpoint
    azurerm_spn_tenantid – The tenant id for the service principal
    azurerm_subscription_id – The subscription id for the target subscription
    azurerm_subscription_name – The name for the target subscription
*/
resource "azuredevops_serviceendpoint_azurerm" "endpoint_connection_sp" {
  project_id            = azuredevops_project.test_project.id
  service_endpoint_name = "AzureRMConnection"
  credentials {
    serviceprincipalid  = azuread_service_principal.tf_sp.application_id
    serviceprincipalkey = azuread_service_principal_password.tf_sp_pass.value
  }
  azurerm_spn_tenantid      = var.azurerm_spn_tenant_id
  azurerm_subscription_id   = var.azurerm_subscription_id
  azurerm_subscription_name = var.subscription_name
}

## Grant permission to use service connection
resource "azuredevops_resource_authorization" "auth" {
  project_id  = azuredevops_project.test_project.id
  resource_id = azuredevops_serviceendpoint_azurerm.endpoint_connection_sp.id
  authorized  = true
}
