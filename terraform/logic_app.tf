resource "azurerm_logic_app_workflow" "logic_app" {
  name                = "ek-logic-app"
  location            = azurerm_resource_group.logic_app.location
  resource_group_name = azurerm_resource_group.logic_app.name

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_app_service_plan" "logic_app" {
  name                = "standard-logic-app-asp"
  location            = azurerm_resource_group.logic_app.location
  resource_group_name = azurerm_resource_group.logic_app.name

  sku {
    tier = "WorkflowStandard"
    size = "WS1"
  }
}

resource "azurerm_logic_app_standard" "logic_app" {
  name                       = "ek-standard-logic-app"
  location                   = azurerm_resource_group.logic_app.location
  resource_group_name        = azurerm_resource_group.logic_app.name
  app_service_plan_id        = azurerm_app_service_plan.logic_app.id
  storage_account_name       = azurerm_storage_account.logic_app.name
  storage_account_access_key = azurerm_storage_account.logic_app.primary_access_key

  identity {
    type = "SystemAssigned"
  }
}