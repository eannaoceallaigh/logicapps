resource "azurerm_logic_app_workflow" "logic_app" {
  name                = "ek-logic-app"
  location            = azurerm_resource_group.logic_app.location
  resource_group_name = azurerm_resource_group.logic_app.name

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_resource_group_template_deployment" "logic_app" {
  resource_group_name = azurerm_resource_group.logic_app.name
  deployment_mode     = "Incremental"
  name                = "logic-app-deployment"
  parameters_content = jsonencode({
    "logic_app_name" = { value = azurerm_logic_app_workflow.logic_app.name }
    "key_vault_secret" = { value = "https://${azurerm_key_vault.logic_app.name}.vault.azure.net/secrets/${azurerm_key_vault_secret.api_key.name}/" }
    "blob_storage_uri" = { value = "${azurerm_storage_account.logic_app.primary_blob_endpoint}json/@{utcNow()}" }
    "rest_api_uri" = { value = "https://ifconfig.me/all.json" }
    "location" = { value = azurerm_resource_group.logic_app.location }
  })
  template_content = data.local_file.logic_app.content
}

