provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

provider "azuread" {

}

provider "random" {

}

terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "0.1.4"
    }
  }
}

provider "azuredevops" {
  org_service_url       = var.org_url
  personal_access_token = var.pat
}