variable "subscription_id" {
  type      = string
  sensitive = false
}

variable "tenant_id" {
  type      = string
  sensitive = false
}

variable "client_id" {
  type      = string
  sensitive = false
}

variable "client_secret" {
  type      = string
  sensitive = true
}

variable "core_infra_resource_group_name" {
  type    = string
  default = "core-infra"
}

variable "location" {
  type    = string
  default = "eastus2"
}

variable "sql_admin_user" {
  type = string
}

variable "sql_admin_pass" {
  type      = string
  sensitive = true
}

variable "dns_zone_name" {
  type = string
}

variable "network_name" {
  type = string
}

variable "app_name" {
  type = string
}