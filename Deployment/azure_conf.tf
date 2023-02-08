variable "scope" {
  default = "/subscriptions/<SubscriptionID>"
}
variable "scope_id" {
  default = "<SubscriptionID>"
}

variable "azurerm_spn_tenant_id" {
  description = "Tenant ID for the service principal"
  type        = string
  default     = "<TenantID>"

}

variable "azurerm_subscription_id" {
  description = "Subscription ID for the target subscription"
  type        = string
  default     = "<SubscriptionID>"

}

variable "org_url" {
  description = "Organization url"
  default     = "https://dev.azure.com/personalorganization/"
}

variable "pat" {
  description = "Personal Access Token"
  default     = "<Personal_Token>"
}