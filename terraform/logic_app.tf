resource "azurerm_logic_app_workflow" "logic_app" {
  name                = "ek-logic-app"
  location            = azurerm_resource_group.logic_app.location
  resource_group_name = azurerm_resource_group.logic_app.name

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_template_deployment" "logicApp" {
  resource_group_name = azurerm_resource_group.logic_app.name
  deployment_mode     = "Incremental"
  name                = "logic-app-deployment"
  parameters = {
    workflows_logic_app_name = azurerm_logic_app_workflow.logic_app.name
    location            = azurerm_resource_group.logic_app.location
    keyVaultSecret      = "https://${azurerm_key_vault.logic_app.name}.vault.azure.net/${azurerm_key_vault_secret.mySecret.name}"
  }
  template_body = data.local_file.logic_app.content
}
