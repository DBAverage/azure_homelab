resource "azurerm_subnet" "integration-subnet" {
  name                 = "${var.app_name}-integration-subnet"
  resource_group_name  = var.core_infra_resource_group_name
  virtual_network_name = data.azurerm_virtual_network.network-1.name
  address_prefixes     = ["10.0.3.0/24"]
  delegation {
    name = "delegation"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
    }
  }
}

# resource "azurerm_subnet" "endpoint-subnet" {
#   name                 = "${var.app_name}-endpoint-subnet"
#   resource_group_name  = azurerm_resource_group.resource-1.name
#   virtual_network_name = data.azurerm_virtual_network.network-1.name
#   address_prefixes     = ["10.0.4.0/24"]
#   private_endpoint_network_policies_enabled = true
# }

resource "azurerm_service_plan" "app-service-1" {
  name                = "${var.app_name}-service-1"
  resource_group_name = azurerm_resource_group.resource-1.name
  location            = azurerm_resource_group.resource-1.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "app-1" {
  name                = "${var.app_name}-app-1"
  resource_group_name = azurerm_resource_group.resource-1.name
  location            = azurerm_service_plan.app-service-1.location
  service_plan_id     = azurerm_service_plan.app-service-1.id
  https_only            = true
  virtual_network_subnet_id = azurerm_subnet.subnet-1.id
  site_config { 
    always_on = false
    minimum_tls_version = "1.2"    
    application_stack {
      node_version = "18-lts"
    }
  }

  app_settings = {
    "test_key" = "test_value"
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "vnet-integration-connection" {
  app_service_id  = azurerm_linux_web_app.app-1.id
  subnet_id       = azurerm_subnet.integration-subnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns-zone-link" {
  name = "${var.app_name}-dns-link-1"
  resource_group_name = azurerm_resource_group.resource-1.name
  private_dns_zone_name = data.azurerm_private_dns_zone.dns-zone-1.name
  virtual_network_id = data.azurerm_virtual_network.network-1.id
}

resource "azurerm_app_service_source_control" "sourcecontrol" {
  app_id             = azurerm_linux_web_app.app-1.id
  repo_url           = "https://github.com/DBAverage/azure-app-service-scratch"
  branch             = "main"
  use_manual_integration = true
  use_mercurial      = false
}