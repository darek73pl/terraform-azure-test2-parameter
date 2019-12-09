terraform {
  backend "azurerm" {
    resource_group_name  = "Terraform-RG"
    storage_account_name = "terraformstorageaccount1"
    container_name       = "terraform-state-test2-parameter"
    key                  = "terraform.tfstate"
  }
}

