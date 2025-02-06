
variable "resource_group_name" {
  type    = string
  default = "mohitkhosla-test-devops-assignment-rg"
}

variable "key_vault_firewall_bypass_ip_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "location" {
  default = "eastus2"
}

variable "log_analytics_workspace_location" {
  default = "eastus2"
}

variable "managed_identity_principal_id" {
  type    = string
  default = null
}

variable "resource_group_name" {
  type = string
  default = null
}

variable "use_brown_field_application_gateway" {
  type    = bool
  default = false
}

variable "create_role_assignments_for_application_gateway" {
  type    = bool
  default = true
}

variable "bring_your_own_vnet" {
  type    = bool
  default = true
}


