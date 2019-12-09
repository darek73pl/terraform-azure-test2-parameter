variable vnet_name {
    type    = string
    default = "vnet1"
}

variable RG_name {
    type    = string
}

variable vnet_location {
    type    = string
}

variable vnet_address_space {
    type    = string
    default = "10.0.0.0/16"
}

variable vnet_subnets {
    type    = list(string)
    default = ["subnet1"]
}

variable vnet_subnet_prefixes {
    type    = list(string)
    default = ["10.0.1.0/24"]
}

variable vnet_sub_allow_rdp {
    type    = list(bool)
    default = [true]
}

variable vnet_sub_allow_http {
    type    = list(bool)
    default = [true]
}