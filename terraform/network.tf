resource "azurerm_virtual_network" "logic_app" {
  name                = "logic-app-vnet"
  location            = azurerm_resource_group.logic_app.location
  resource_group_name = azurerm_resource_group.logic_app.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "logic_app" {
  name                 = "logic-app-subnet"
  resource_group_name  = azurerm_resource_group.logic_app.name
  virtual_network_name = azurerm_virtual_network.logic_app.name
  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints = ["Microsoft.Storage"]
}

resource "azurerm_private_endpoint" "logic_app" {
  name                = "logic-app-endpoint"
  location            = azurerm_resource_group.logic_app.location
  resource_group_name = azurerm_resource_group.logic_app.name
  subnet_id           = azurerm_subnet.logic_app.id

  private_service_connection {
    name                              = "logic-app-psc"
    is_manual_connection              = true
    private_connection_resource_id = azurerm_storage_account.logic_app.id
    subresource_names = ["blob"]
    request_message                   = "PL"
  }

  private_dns_zone_group {
    name = "privatelink.blob.core.windows.net"
    private_dns_zone_ids = [azurerm_private_dns_zone.logic_app.id]
  }
}

resource "azurerm_private_dns_zone" "logic_app" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.logic_app.name
}