resource "azurerm_logic_app_workflow" "logic_app_workflow" {
  name                = "ek-logic-app"
  location            = azurerm_resource_group.logic_app_rg.location
  resource_group_name = azurerm_resource_group.logic_app_rg.name

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_resource_group_template_deployment" "logic_app_deployment" {
  resource_group_name = azurerm_resource_group.logic_app_rg.name
  deployment_mode     = "Incremental"
  name                = "logic-app-deployment"

  template_content = data.local_file.logic_app.content

  parameters_content = jsonencode({
    "logic_app_name" = { value = azurerm_logic_app_workflow.logic_app_workflow.name }
    "key_vault_secret" = { value = "https://${azurerm_key_vault.logic_app_kv.name}.vault.azure.net/secrets/${azurerm_key_vault_secret.api_key.name}/" }
    "blob_storage_uri" = { value = "${azurerm_storage_account.logic_app_sa.primary_blob_endpoint}json/@{utcNow()}" }
    "rest_api_uri" = { value = "https://ifconfig.me/all.json" }
    "location" = { value = azurerm_resource_group.logic_app_rg.location }
  })
}

