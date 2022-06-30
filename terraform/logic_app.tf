resource "azurerm_logic_app_workflow" "logic_app" {
  name                = "ek-logic-app"
  location            = azurerm_resource_group.logic_app.location
  resource_group_name = azurerm_resource_group.logic_app.name

  identity {
    type = "SystemAssigned"
  }
}

locals {
  parameters_content = {
    keyVaultSecret = "https://${azurerm_key_vault.logic_app.name}.vault.azure.net/${azurerm_key_vault_secret.mySecret.name}"
    workflows_logic_app_name = azurerm_logic_app_workflow.logic_app.name
  }
}

resource "azurerm_resource_group_template_deployment" "logicApp" {
  resource_group_name = azurerm_resource_group.logic_app.name
  deployment_mode     = "Incremental"
  name                = "logic-app-deployment"
  parameters_content  = jsonencode(local.parameters_content)
  template_content = data.local_file.logic_app.content
}
