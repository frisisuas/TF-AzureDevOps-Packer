#Necesitaremos un SP para ejecutar los pipelines
resource "azuread_application" "tf_app" {
  display_name = var.tf_app_name
}
resource "azuread_service_principal" "tf_sp" {
  application_id = azuread_application.tf_app.application_id
}
# Añadimos el rol al SP.
resource "azurerm_role_assignment" "sp_rol" {
  principal_id         = azuread_service_principal.tf_sp.object_id
  scope                = var.scope
  role_definition_name = "Contributor"
}

# Generador de contraseña para el SP con una longitud de 32 carácteres.
resource "random_password" "password" {
  length  = 32
  special = true
}
resource "time_rotating" "sp_passwd_rotation" {
  rotation_days = 7
}

# Aplicación de la contraseña al SP y su validez.
resource "azuread_service_principal_password" "tf_sp_pass" {
  service_principal_id = azuread_service_principal.tf_sp.id
  rotate_when_changed = {
    rotation = time_rotating.sp_passwd_rotation.id
  }
  end_date_relative    = "8760h"
}
# Generador de 5 caracteres para el account storage.
resource "random_string" "randomize" {
  length  = 5
  lower   = true
  upper   = false
  numeric = false
  special = false
}