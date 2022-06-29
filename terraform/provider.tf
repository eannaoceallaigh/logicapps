terraform {
  backend "azurerm" {}

  required_version = ">= 1.2.0"
  required_providers {
    azurerm = "3.10.0"
  }
}


provider "azurerm" {
  features {}
}