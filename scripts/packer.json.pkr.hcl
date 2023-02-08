
variable "ADOServicePrincipalAppId" {
  type    = string
  default = ""
}

variable "ADOServicePrincipalSecret" {
  type    = string
  default = ""
}

variable "Build_BuildNumber" {
  type    = string
  default = "${env("Build_BuildNumber")}"
}

variable "Build_DefinitionName" {
  type    = string
  default = "${env("Build_DefinitionName")}"
}

variable "ImageDestRG" {
  type    = string
  default = ""
}

variable "ImageOffer" {
  type    = string
  default = "WindowsServer"
}

variable "ImagePublisher" {
  type    = string
  default = "MicrosoftWindowsServer"
}

variable "ImageSku" {
  type    = string
  default = "2022-Datacenter"
}

variable "Location" {
  type    = string
  default = ""
}

variable "StorageAccountInstallersKey" {
  type    = string
  default = ""
}

variable "StorageAccountInstallersName" {
  type    = string
  default = ""
}

variable "StorageAccountInstallersPath" {
  type    = string
  default = ""
}

variable "Subnet" {
  type    = string
  default = ""
}

variable "SubscriptionId" {
  type    = string
  default = ""
}

variable "TempResourceGroup" {
  type    = string
  default = ""
}

variable "TenantId" {
  type    = string
  default = ""
}

variable "VMSize" {
  type    = string
  default = ""
}

variable "VirtualNetwork" {
  type    = string
  default = ""
}

variable "VirtualNetworkRG" {
  type    = string
  default = ""
}
# The "legacy_isotime" function has been provided for backwards compatability, but we recommend switching to the timestamp and formatdate functions.

source "azure-arm" "windows_server_2022" {
  async_resourcegroup_delete = true
  azure_tags = {
    "Image Offer"     = "${var.ImageOffer}"
    "Image Publisher" = "${var.ImagePublisher}"
    "Image SKU"       = "${var.ImageSku}"
  }
  client_id                              = "${var.ADOServicePrincipalAppId}"
  client_secret                          = "${var.ADOServicePrincipalSecret}"
  communicator                           = "winrm"
  image_offer                            = "${var.ImageOffer}"
  image_publisher                        = "${var.ImagePublisher}"
  image_sku                              = "${var.ImageSku}"
  location                               = "${var.Location}"
  managed_image_name                     = "${var.Build_DefinitionName}-${legacy_isotime("2006-01-02-1504")}-Build${var.Build_BuildNumber}"
  managed_image_resource_group_name      = "${var.ImageDestRG}"
  os_type                                = "Windows"
  private_virtual_network_with_public_ip = "True"
  subscription_id                        = "${var.SubscriptionId}"
  temp_resource_group_name               = "${var.TempResourceGroup}"
  tenant_id                              = "${var.TenantId}"
  virtual_network_name                   = "${var.VirtualNetwork}"
  virtual_network_resource_group_name    = "${var.VirtualNetworkRG}"
  virtual_network_subnet_name            = "${var.Subnet}"
  vm_size                                = "${var.VMSize}"
  winrm_insecure                         = "true"
  winrm_port                             = "5986"
  winrm_timeout                          = "10m"
  winrm_use_ssl                          = "true"
  winrm_username                         = "packer"
}

build {
  sources = ["source.azure-arm.windows_server_2022"]

  provisioner "powershell" {
    inline = ["$ErrorActionPreference='Stop'", "Test-NetConnection -ComputerName ${var.StorageAccountInstallersName}.file.core.windows.net -Port 445", "Import-Module -Name Smbshare -Force -Scope Local", "New-SmbMapping -LocalPath Z: -RemotePath \"\\\\${var.StorageAccountInstallersName}.file.core.windows.net\\installers\" -Username \"Azure\\${var.StorageAccountInstallersName}\" -Password \"${var.StorageAccountInstallersKey}\"", "Write-Host \"'Z:' drive mapped\""]
  }

  provisioner "powershell" {
    inline = ["powershell.exe Z:\\\\scripts\\hello_world.ps1"]
  }

  provisioner "powershell" {
    inline = ["powershell.exe Z:\\\\scripts\\install_iis.ps1"]
  }

  provisioner "powershell" {
    inline = [" # NOTE: the following *4* lines are only needed if the you have installed the Guest Agent.", "  while ((Get-Service RdAgent).Status -ne 'Running') { Start-Sleep -s 5 }", "  while ((Get-Service WindowsAzureGuestAgent).Status -ne 'Running') { Start-Sleep -s 5 }", "& $env:SystemRoot\\System32\\Sysprep\\Sysprep.exe /oobe /generalize /quiet /quit /mode:vm", "while($true) { $imageState = Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State | Select ImageState; if($imageState.ImageState -ne 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { Write-Output $imageState.ImageState; Start-Sleep -s 10  } else { break } }"]
  }

}
