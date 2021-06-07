variable "location" {
  type    = string
  default = "westeurope"
}
variable "rgname" {
  type    = string
  default = "packer-resources"
}

variable "app_dev" {
  description = "Rol en el AD para crear nuestro Service Principal"
  type        = string
  default     = "Contributor"
}
variable "tf_app_name" {
  description = "Nombre del service principal que usaremos para Terraform"
  type        = string
  default     = "packer-deploys"
}

variable "subscription_name" {
  description = "The name for the target subscription"
  default     = "<Subscription_Name>"
}
resource "null_resource" "previous" {}

resource "time_sleep" "wait_30_seconds" {
  depends_on = [null_resource.previous]

  create_duration = "30s"
}



