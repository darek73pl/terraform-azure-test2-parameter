output "vnet_id" {
    value = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
    value = azurerm_virtual_network.vnet.name
}

output "vnet_subnet_ids" {
    value = azurerm_subnet.vnet_subnet[*].id
}

output "vnet_subnet_names" {
    value = azurerm_subnet.vnet_subnet[*].name
}

output "vnet_sub_nsg_ids" {
    value = azurerm_network_security_group.vnet_sub_nsg[*].id
}

output "vnet_sub_nsg_names" {
    value = azurerm_network_security_group.vnet_sub_nsg[*].name
}