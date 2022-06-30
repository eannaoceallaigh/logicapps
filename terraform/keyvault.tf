resource "azurerm_key_vault" "logic_app" {
  name                        = "logic-app-keyvault"
  location                    = azurerm_resource_group.logic_app.location
  resource_group_name         = azurerm_resource_group.logic_app.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"
}

resource "azurerm_key_vault_access_policy" "logic_app_identity" {
  key_vault_id = azurerm_key_vault.logic_app.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_logic_app_workflow.logic_app.identity[0].principal_id

  secret_permissions = [
    "Get",
    "List"
  ]
}

resource "azurerm_key_vault_access_policy" "ado_identity" {
  key_vault_id = azurerm_key_vault.logic_app.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete"
  ]
}

resource "azurerm_key_vault_secret" "example" {
  name         = "notARealSecret"
  value        = "seriously, this is not a real secret"
  key_vault_id = azurerm_key_vault.logic_app.id
}
