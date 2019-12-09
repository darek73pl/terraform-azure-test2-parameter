output vm_names {
    value = [ for v in var.vm_names : azurerm_virtual_machine.vm[v].name ]
}

output vm_ids {
    value = [ for v in var.vm_names : azurerm_virtual_machine.vm[v].id ]
}
