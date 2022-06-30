terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-state"
    storage_account_name = "ekterraformstate"
    container_name       = "terraform"
    key                  = "terraform.tfstate"
  }

  required_version = ">= 1.2.0"
  required_providers {
    azurerm = "3.10.0"
  }
}


provider "azurerm" {
  features {
    template_deployment {
      delete_nested_items_during_deletion = false
    }
  }
}
