# https://learn.microsoft.com/en-us/azure/vpn-gateway/tutorial-site-to-site-portal?WT.mc_id=AZ-MVP-5004796
# https://luke.geek.nz/azure/create-a-site-to-site-vpn-to-azure-with-a-ubiquiti-dream-machine-pro/

resource "azurerm_resource_group" "resource-1" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = "infra"
  }
}

resource "azurerm_virtual_network" "network-1" {
  name                = "core-network-1"
  location            = azurerm_resource_group.resource-1.location
  resource_group_name = azurerm_resource_group.resource-1.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = "mssql"
  }
}

resource "azurerm_subnet" "subnet-1" {
  name                                           = "GatewaySubnet"
  address_prefixes                               = ["10.0.1.0/24"]
  virtual_network_name                           = azurerm_virtual_network.network-1.name
  resource_group_name                            = azurerm_resource_group.resource-1.name
  private_endpoint_network_policies_enabled      = true
}

resource "azurerm_subnet" "subnet-18" {
  name                                           = "dns-resolver-subnet"
  address_prefixes                               = ["10.0.18.0/24"]
  virtual_network_name                           = azurerm_virtual_network.network-1.name
  resource_group_name                            = azurerm_resource_group.resource-1.name

  delegation {
    name = "Microsoft.Network.dnsResolvers"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      name    = "Microsoft.Network/dnsResolvers"
    }
  }
}

resource "azurerm_public_ip" "public_ip" {
  name                = "public_ip_1"
  sku                 = "Basic"
  location            = azurerm_resource_group.resource-1.location
  resource_group_name = azurerm_resource_group.resource-1.name

  allocation_method = "Dynamic"
}

data "http" "my_public_ip" {
  url = "http://ipv4.icanhazip.com"
}

# models my local/home network in azure
resource "azurerm_local_network_gateway" "home" {
  name                = "128_columbia_blvd"
  resource_group_name = azurerm_resource_group.resource-1.name
  location            = azurerm_resource_group.resource-1.location
  gateway_address     = chomp(data.http.my_public_ip.response_body)                                                         # home public ip address
  address_space       = ["192.168.0.0/24", "192.168.1.0/24", "192.168.2.0/24", "192.168.5.0/24", "192.168.6.0/24"] # home subnets
}

# # gateway between my local/home network and azure network
# # need to update unifi vpn with this ip address when it changes
resource "azurerm_virtual_network_gateway" "azure" {
  name                = "azure"
  location            = azurerm_resource_group.resource-1.location
  resource_group_name = azurerm_resource_group.resource-1.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "Basic"

  ip_configuration {
    public_ip_address_id          = azurerm_public_ip.public_ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.subnet-1.id
  }
}

resource "azurerm_virtual_network_gateway_connection" "azure-to-home" {
  name                = "azure-to-home"
  location            = azurerm_resource_group.resource-1.location
  resource_group_name = azurerm_resource_group.resource-1.name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.azure.id
  local_network_gateway_id   = azurerm_local_network_gateway.home.id

  shared_key = var.shared_key
}

