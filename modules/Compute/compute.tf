#####################################################################
#                                                                   #
#  Module building VM                                               #
#  OS - Windows Server 2016 Database                                #
#  possible options: - public IP                                    #
#                    - availability set                             #
#                    - VM size                                      #
#                                                                   #
#####################################################################


locals {
  map_all_vms      = { for v in var.vm_names : v => v}
  map_vm_with_pips = { for v in var.vm_with_pips : v => v}
}

data "azurerm_subnet" "vm_subnet" {
  name                 = var.vm_subnet
  virtual_network_name = var.vm_vnet
  resource_group_name  = var.RG_name
}

resource "azurerm_availability_set" "vm_AS" {
  count               = var.vm_AS == true ? 1 :0
  name                = "${var.vm_vnet}-${var.vm_subnet}-AS"
  location            = var.vm_location
  resource_group_name = var.RG_name
  managed             = true
}

resource "azurerm_network_interface" "vm_nic" {
  for_each            = local.map_all_vms
  name                = "${var.vm_vnet}-${var.vm_subnet}-${each.key}-nic"
  location            = var.vm_location
  resource_group_name = var.RG_name

  ip_configuration {
    name                          = "${var.vm_vnet}-${var.vm_subnet}-${each.key}-nic-config0"
    subnet_id                     = data.azurerm_subnet.vm_subnet.id 
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = contains(var.vm_with_pips,each.key) ? azurerm_public_ip.vm_nic_pip[each.key].id : ""
  }
}
resource "azurerm_public_ip" "vm_nic_pip" {
  for_each            = local.map_vm_with_pips
  name                = "${var.vm_vnet}-${var.vm_subnet}-${each.key}-nic-pip"
  location            = var.vm_location
  resource_group_name = var.RG_name
  allocation_method   = "Dynamic"
}

resource "azurerm_virtual_machine" "vm" {
  for_each              = local.map_all_vms
  name                  = "${var.vm_vnet}-${var.vm_subnet}-${each.key}"
  location              = var.vm_location
  resource_group_name   = var.RG_name
  network_interface_ids = [azurerm_network_interface.vm_nic[each.key].id]
  vm_size               = var.vm_size
  availability_set_id   = var.vm_AS == true ? azurerm_availability_set.vm_AS[0].id : ""
  license_type          = "Windows_Server"

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  storage_os_disk {
    name              = lower("${var.vm_vnet}-${var.vm_subnet}-${each.key}-os-disk")
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "${var.vm_vnet}-${var.vm_subnet}-${each.key}"
    admin_username = var.vm_admin_username
    admin_password = var.vm_admin_password
  }
  
  os_profile_windows_config {
    enable_automatic_upgrades = true
    provision_vm_agent        = true
  }
}