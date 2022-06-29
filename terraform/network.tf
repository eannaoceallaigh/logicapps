resource "azurerm_virtual_network" "logic_app" {
  name                = "logic-app-vnet"
  location            = azurerm_resource_group.logic_app.location
  resource_group_name = azurerm_resource_group.logic_app.name
  address_space       = ["10.0.0.0/16"]

  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "subnet2"
    address_prefix = "10.0.2.0/24"
  }
}

resource "azurerm_private_endpoint" "logic_app" {
  name                = "logic-app-endpoint"
  location            = azurerm_resource_group.logic_app.location
  resource_group_name = azurerm_resource_group.logic_app.name
  subnet_id           = azurerm_virtual_network.logic_app.subnet_ids[0]

  private_service_connection {
    name                              = "logic-app-psc"
    is_manual_connection              = true
    subresource_names = "blob"
  }
}