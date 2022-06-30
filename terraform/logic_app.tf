resource "azurerm_logic_app_workflow" "logic_app" {
  name                = "ek-logic-app"
  location            = azurerm_resource_group.logic_app.location
  resource_group_name = azurerm_resource_group.logic_app.name
  workflow_parameters = {
    keyVaultSecret = azurerm_key_vault_secret.mySecret.value
  }

  identity {
    type = "SystemAssigned"
  }
}
