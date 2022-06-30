data "azurerm_client_config" "current" {
}

data "local_file" "logic_app" {
  filename = "./workflow.json"
}
