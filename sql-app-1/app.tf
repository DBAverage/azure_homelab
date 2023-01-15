resource "azurerm_service_plan" "app-service-1" {
  name                = "${var.app_name}-service-1"
  resource_group_name = azurerm_resource_group.resource-1.name
  location            = azurerm_resource_group.resource-1.location
  os_type             = "Linux"
  sku_name            = "P1v2"
}

resource "azurerm_linux_web_app" "app-1" {
  name                = "${var.app_name}-app-1"
  resource_group_name = azurerm_resource_group.resource-1.name
  location            = azurerm_service_plan.app-service-1.location
  service_plan_id     = azurerm_service_plan.app-service-1.id

  site_config {}
}