location = "West Europe"

RG_name = {
    "dev"  = "RG-dev"
    "prod" = "RG-prod"
}

vnet_address_space = {
    "dev"  = "10.100.0.0/16"
    "prod" = "10.200.0.0/16"
} 

vnet_subnets = {
    "dev"  = ["sub1", "sub2"]
    "prod" = ["sub1"]
}

vnet_subnet_prefixes = {
    "dev"  = ["10.100.10.0/24", "10.100.20.0/24"]
    "prod" = ["10.200.20.0/24"]
}

vnet_sub_allow_rdp = {
    "dev"  = [true,true]
    "prod" = [true]
}

vnet_sub_allow_http = {
    "dev"  = [true, false]
    "prod" = [true]
}

vm_names = {
    "dev"  = ["vd1", "vd2"]
    "prod" = ["vp1"]
}

vm_with_pips = {
    "dev"   = ["vd1"]
    "prod"  = ["vp1"]
}

vm_AS = {
    "dev"  = true
    "prod" = true
}

vm_admin_username = "azadmin"
    