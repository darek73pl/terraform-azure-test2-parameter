variable vm_names {
    type    = list(string)
    default = ["vm1"]
}

variable vm_with_pips {
    type    = list(string)
    default = []
}

variable RG_name {
    type    = string
}

variable vm_location {
    type    = string
}

variable vm_subnet {
    type    = string
}

variable vm_vnet {
    type    = string
}

variable vm_AS {
    type    = bool
    default = true
}

variable vm_size {
    type    = string
    default = "Standard_B1ms"
}

variable vm_admin_username {
    type = string
}

variable vm_admin_password {
    type = string
}