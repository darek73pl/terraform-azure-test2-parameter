#####################################################################
#                                                                   #
#  Creating  Web tier                                               #
#                                                                   #
#####################################################################


data "azurerm_storage_account" "extension_source" {
  name                = "dartest01"
  resource_group_name = "Constant-RG"
}

resource "azurerm_resource_group" "RG1" {
  name     = var.RG_name[terraform.workspace]
  location = var.location

  tags = {
    environment = "Production"
    owner       = "Darek" 
  }
}

module "vnet1" {
  source = "./modules/Network"

  RG_name              = azurerm_resource_group.RG1.name
  vnet_location        = var.location 
  vnet_name            = "${terraform.workspace}"
  vnet_address_space   = var.vnet_address_space[terraform.workspace]
  vnet_subnets         = var.vnet_subnets[terraform.workspace]
  vnet_subnet_prefixes = var.vnet_subnet_prefixes[terraform.workspace]
  vnet_sub_allow_rdp   = var.vnet_sub_allow_rdp[terraform.workspace]
  vnet_sub_allow_http  = var.vnet_sub_allow_http[terraform.workspace]
}

module "web_tier" {
  source = "./modules/Compute"

  RG_name           = azurerm_resource_group.RG1.name
  vm_location       = var.location 
  vm_names          = var.vm_names[terraform.workspace]
  vm_with_pips      = var.vm_with_pips[terraform.workspace]
  vm_vnet           = module.vnet1.vnet_name
  vm_subnet         = module.vnet1.vnet_subnet_names[0]
  vm_AS             = var.vm_AS[terraform.workspace]
  vm_admin_username = var.vm_admin_username
  vm_admin_password = var.vm_admin_password
}

resource "azurerm_virtual_machine_extension" "web_server_ext" {
  count                = length(module.web_tier.vm_names)
  name                 = "web-server-ext"
  location             = var.location
  resource_group_name  = azurerm_resource_group.RG1.name
  virtual_machine_name = module.web_tier.vm_names[count.index]
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"
  
settings = <<SETTINGS
    {
        "fileUris": ["https://dartest01.blob.core.windows.net/extensions/azureInstallWebServer.ps1"]
    }
SETTINGS
  protected_settings = <<PROTECTED_SETTINGS
    {
      "commandToExecute"   : "powershell -ExecutionPolicy Unrestricted -NoProfile -NonInteractive -File azureInstallWebServer.ps1",
      "storageAccountName" : "${data.azurerm_storage_account.extension_source.name}",
      "storageAccountKey"  : "${data.azurerm_storage_account.extension_source.primary_access_key}"
    }
  PROTECTED_SETTINGS
/* 
or from public github

settings = <<SETTINGS
    {
        "fileUris": ["https://raw.githubusercontent.com/eltimmo/learning/master/azureInstallWebServer.ps1"],
        "commandToExecute": "powershell -ExecutionPolicy Unrestricted -NoProfile -NonInteractive -File azureInstallWebServer.ps1"
    }
    SETTINGS
*/
}

output "subnet_amount" {
    value =length(module.vnet1.vnet_subnet_ids)
} 

output "vm_names_1" {
    value = module.web_tier.vm_names
}

output "vm_ids_1" {
    value = module.web_tier.vm_ids
}
