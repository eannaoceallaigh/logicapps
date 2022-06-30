resource "azurerm_key_vault" "logic_app" {
  name                        = "logic-app-keyvault"
  location                    = azurerm_resource_group.logic_app.location
  resource_group_name         = azurerm_resource_group.logic_app.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  enable_rbac_authorization = true

  sku_name = "standard"
}

# resource "azurerm_role_assignment" "ado_kv_access" {
#   scope              = azurerm_resource_group.logic_app.id
#   role_definition_name = "Key Vault Secrets Officer"
#   principal_id       = data.azurerm_client_config.current.object_id
# }

resource "azurerm_role_assignment" "logic_app_kv_access" {
  scope              = azurerm_key_vault.logic_app.id
  role_definition_name = "Key Vault Secrets User"
  principal_id       = azurerm_logic_app_workflow.logic_app.identity[0].principal_id
}

resource "azurerm_key_vault_secret" "mySecret" {
  name         = "notARealSecret"
  value        = "seriously, this is not a real secret"
  key_vault_id = azurerm_key_vault.logic_app.id
}
