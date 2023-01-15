# output "azurerm_private_dns_zone" {
#   value = azurerm_private_dns_zone.dns-zone-1
# }

# this is the ip address to use in the unifi site-to-site setup 
output "remote_ip_address_for_unifi_vpn" {
  value = azurerm_public_ip.public_ip.ip_address
}

# output "health_probe_url" {
#   value = "https://${azurerm_public_ip.public_ip.ip_address}:8081/healthprobe"
# }

output "dns_resolver_ip" {
  value = azurerm_private_dns_resolver_inbound_endpoint.dns_inbound_endpoint.ip_configurations[0].private_ip_address
}