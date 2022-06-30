data "azurerm_client_config" "current" {
}

data "local_file" "dnLogicApp" {
  filename = "./workflow.json"
}
