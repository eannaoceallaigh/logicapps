resource "azurerm_logic_app_workflow" "logic_app" {
  name                = "ek-logic-app"
  location            = azurerm_resource_group.logic_app.location
  resource_group_name = azurerm_resource_group.logic_app.name

  identity {
    type = "SystemAssigned"
  }
}

locals {
    keyVaultSecret = "https://${azurerm_key_vault.logic_app.name}.vault.azure.net/${azurerm_key_vault_secret.mySecret.name}"
#     "workflows_logic_app_name" = azurerm_logic_app_workflow.logic_app.name
}


resource "azurerm_template_deployment" "logic_app" {
  resource_group_name = azurerm_resource_group.logic_app.name
  deployment_mode     = "Incremental"
  name                = "logic-app-deployment"
  parameters = {
#     workflows_flow_name = azurerm_logic_app_workflow.logic_app.name
#     location            = azurerm_resource_group.logic_app.location
    "keyVaultSecret" = "https://${azurerm_key_vault.logic_app.name}.vault.azure.net/${azurerm_key_vault_secret.mySecret.name}"
  }
  template_body = data.local_file.logic_app.content
}

# resource "azurerm_resource_group_template_deployment" "logicApp" {
#   resource_group_name = azurerm_resource_group.logic_app.name
#   deployment_mode     = "Incremental"
#   name                = "logic-app-deployment"
#   parameters_content  = jsonencode(local.parameters_content)
#   template_content = data.local_file.logic_app.content
# }

# resource "azurerm_logic_app_trigger_http_request" "logic_app" {
#   name         = "http-trigger"
#   logic_app_id = azurerm_logic_app_workflow.logic_app.id

#   schema = <<SCHEMA
# {}
# SCHEMA

# }

# resource "azurerm_logic_app_action_http" "example" {
#   name         = "Get KyeVault Secret"
#   logic_app_id = azurerm_logic_app_workflow.logic_app.id
#   method       = "GET"
#   uri          = "https://${azurerm_key_vault.logic_app.name}.vault.azure.net/${azurerm_key_vault_secret.mySecret.name}"
#   body = <<BODY
#   {
#                     "inputs": {
#                     "authentication": {
#                         "audience": "https://vault.azure.net",
#                         "type": "ManagedServiceIdentity"
#                     },
#                                           "queries": {
#                         "api-version": "2016-10-01"
#                     }
#                     }
# }
# BODY
#   }
