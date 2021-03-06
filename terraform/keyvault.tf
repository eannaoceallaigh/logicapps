resource "azurerm_key_vault" "logic_app_kv" {
  name                        = "logic-app-keyvault"
  location                    = azurerm_resource_group.logic_app_rg.location
  resource_group_name         = azurerm_resource_group.logic_app_rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  enable_rbac_authorization = true

  sku_name = "standard"
}

resource "azurerm_role_assignment" "logic_app_kv_access" {
  scope              = azurerm_key_vault.logic_app_kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id       = azurerm_logic_app_workflow.logic_app_workflow.identity[0].principal_id
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_key_vault_secret" "api_key" {
  name         = "notARealSecret"
  value        = random_password.password.result
  key_vault_id = azurerm_key_vault.logic_app_kv.id
}
