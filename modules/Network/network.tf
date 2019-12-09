#####################################################################
#                                                                   #
#  Module building vnet, subset(s), NSGs                            #
#  possible options: - HTTP allow (NSG)                             #
#                    - RDP allow (NSG)                              #
#                                                                   #
#####################################################################

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.vnet_location
  resource_group_name = var.RG_name
  address_space       = [var.vnet_address_space]
}

resource "azurerm_subnet" "vnet_subnet" {
  count                     = length(var.vnet_subnets)
  name                      = var.vnet_subnets[count.index]
  resource_group_name       = var.RG_name
  virtual_network_name      = azurerm_virtual_network.vnet.name
  address_prefix            = var.vnet_subnet_prefixes[count.index]
  
  lifecycle {
    ignore_changes          = [network_security_group_id]
  }
}

resource "azurerm_network_security_group" "vnet_sub_nsg" {
  count               = length(var.vnet_subnets)
  name                = "${var.vnet_name}-${var.vnet_subnets[count.index]}-nsg"
  location            = var.vnet_location
  resource_group_name = var.RG_name
}

resource "azurerm_subnet_network_security_group_association" "vnet_sub_nsg_ass" {
  count                     = length(var.vnet_subnets)
  subnet_id                 = azurerm_subnet.vnet_subnet[count.index].id
  network_security_group_id = azurerm_network_security_group.vnet_sub_nsg[count.index].id

}

resource "azurerm_network_security_rule" "vnet_sub_nsg_rule_RDP" { 
    count                       = length(var.vnet_subnets)
    name                        = var.vnet_sub_allow_rdp[count.index] == true ? "${var.vnet_name}_${var.vnet_subnets[count.index]}_AllowRDP" : "${var.vnet_name}_${var.vnet_subnets[count.index]}_DenyRDP"
    priority                    = 3000
    direction                   = "Inbound"
    access                      = var.vnet_sub_allow_rdp[count.index] == true ? "Allow" : "Deny"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "3389"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    resource_group_name         = var.RG_name
    network_security_group_name = azurerm_network_security_group.vnet_sub_nsg[count.index].name
   
}

resource "azurerm_network_security_rule" "vnet_sub_nsg_rule_HTTP" { 
    count                       = length(var.vnet_subnets)
    name                        = var.vnet_sub_allow_http[count.index] == true ? "${var.vnet_name}_${var.vnet_subnets[count.index]}_AllowHTTP" : "${var.vnet_name}_${var.vnet_subnets[count.index]}_DenyHTTP"
    priority                    = 3100
    direction                   = "Inbound"
    access                      = var.vnet_sub_allow_http[count.index] == true ? "Allow" : "Deny"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "80"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    resource_group_name         = var.RG_name
    network_security_group_name = azurerm_network_security_group.vnet_sub_nsg[count.index].name
}

