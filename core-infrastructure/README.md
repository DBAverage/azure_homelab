# unifi router configuration
Need to update unifi site-to-site vpn with public ip of the virual network gateway

so put the azure virtual network gateways public ip in the remote ip address field on the unifi site-to-site vpn

- perfect forward secrecy should also be disabled on the unifi vpn

- IKE DH Group should also be set to 2 on the unifi vpn

# local dns configuration
Need to add dns_resolver_ip output as dns resolution server