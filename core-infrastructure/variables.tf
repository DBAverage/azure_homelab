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

variable "shared_key" {
  type      = string
  sensitive = true
}

variable "resource_group_name" {
  type    = string
  default = "core-infra"
}

variable "location" {
  type    = string
  default = "eastus2"
}
