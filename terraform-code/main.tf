resource "random_id" "prefix" {
  byte_length = 8
}
resource "azurerm_resource_group" "main" {
  location = var.location
  name     = var.resource_group_name
}
locals {
  resource_group = {
    name     = azurerm_resource_group.main.name
    location = var.location
  }
}
resource "azurerm_virtual_network" "test" {
  address_space       = ["10.52.0.0/16"]
  location            = local.resource_group.location
  name                = "${local.resource_group_name}-vnet"
  resource_group_name = local.resource_group.name
}
resource "azurerm_subnet" "test" {
  address_prefixes     = ["10.52.0.0/24"]
  name                 = "${local.resource_group_name}-aks-snet"
  resource_group_name  = local.resource_group.name
  virtual_network_name = azurerm_virtual_network.test.name
}
locals {
  appgw_cidr = !var.use_brown_field_application_gateway && !var.bring_your_own_vnet ? "10.225.0.0/16" : "10.52.1.0/24"
}
resource "azurerm_subnet" "appgw" {
  address_prefixes     = ["10.52.1.0/24"]
  name                 = "${local.resource_group_name}-aks-appgw-snet"
  resource_group_name  = local.resource_group.name
  virtual_network_name = azurerm_virtual_network.test.name
}
resource "azurerm_user_assigned_identity" "test" {
  location            = local.resource_group.location
  name                = "${local.resource_group_name}-umi"
  resource_group_name = local.resource_group.name
}
# Just for demo purpose, not necessary to named cluster.
resource "azurerm_log_analytics_workspace" "main" {
  location            = coalesce(var.log_analytics_workspace_location, local.resource_group.location)
  name                = "prefix-workspace"
  resource_group_name = local.resource_group.name
  retention_in_days   = 30
  sku                 = "PerGB2018"
}
resource "azurerm_log_analytics_solution" "main" {
  location              = coalesce(var.log_analytics_workspace_location, local.resource_group.location)
  resource_group_name   = local.resource_group.name
  solution_name         = "ContainerInsights"
  workspace_name        = azurerm_log_analytics_workspace.main.name
  workspace_resource_id = azurerm_log_analytics_workspace.main.id
  plan {
    product   = "OMSGallery/ContainerInsights"
    publisher = "Microsoft"
  }
}
resource "azurerm_container_registry" "example" {
  location            = local.resource_group.location
  name                = "mohitacrtest"
  resource_group_name = local.resource_group.name
  sku                 = "Standard"
}

# Locals block for hardcoded names
locals {
  backend_address_pool_name      = try("${azurerm_virtual_network.test.name}-beap", "")
  frontend_ip_configuration_name = try("${azurerm_virtual_network.test.name}-feip", "")
  frontend_port_name             = try("${azurerm_virtual_network.test.name}-feport", "")
  http_setting_name              = try("${azurerm_virtual_network.test.name}-be-htst", "")
  listener_name                  = try("${azurerm_virtual_network.test.name}-httplstn", "")
  request_routing_rule_name      = try("${azurerm_virtual_network.test.name}-rqrt", "")
}
resource "azurerm_public_ip" "pip" {
  allocation_method   = "Static"
  location            = local.resource_group.location
  name                = "appgw-pip"
  resource_group_name = local.resource_group.name
  sku                 = "Standard"
}
resource "azurerm_application_gateway" "appgw" {
  location = local.resource_group.location
  name                = "ingress"
  resource_group_name = local.resource_group.name
  backend_address_pool {
    name = local.backend_address_pool_name
  }
  backend_http_settings {
    cookie_based_affinity = "Disabled"
    name                  = local.http_setting_name
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }
  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.pip.id
  }
  frontend_port {
    name = local.frontend_port_name
    port = 80
  }
  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = azurerm_subnet.appgw.id
  }
  http_listener {
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    name                           = local.listener_name
    protocol                       = "Http"
  }
  request_routing_rule {
    http_listener_name         = local.listener_name
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
    priority                   = 1
  }
  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }
  lifecycle {
    ignore_changes = [
      tags,
      backend_address_pool,
      backend_http_settings,
      http_listener,
      probe,
      request_routing_rule,
      url_path_map,
    ]
  }
}
module "aks" {
  source  = "Azure/aks/azurerm"
  version = "9.4.0"
  prefix                               = "test-aks"
  resource_group_name                  = local.resource_group.name
  admin_username                       = "mohitkhosla07"
  azure_policy_enabled                 = true
  cluster_log_analytics_workspace_name = "test-cluster"
  cluster_name                         = "mohitkhosla-test-aks-cluster"
  disk_encryption_set_id               = azurerm_disk_encryption_set.des.id
  identity_ids                         = [azurerm_user_assigned_identity.test.id]
  identity_type                        = "UserAssigned"
  agents_pool_linux_os_configs = [
    {
      transparent_huge_page_enabled = "always"
      sysctl_configs = [

        {
          fs_aio_max_nr               = 65536
          fs_file_max                 = 100000
          fs_inotify_max_user_watches = 1000000
        }
      ]
    }
  ]
  agents_type            = "VirtualMachineScaleSets"
  log_analytics_solution = {
    id = azurerm_log_analytics_solution.main.id
  }
  log_analytics_workspace_enabled = true
  log_analytics_workspace = {
    id   = azurerm_log_analytics_workspace.main.id
    name = azurerm_log_analytics_workspace.main.name
  }
  maintenance_window = {
    allowed = [
      {
        day   = "Sunday",
        hours = [22, 23]
      },
    ]
    not_allowed = []
  }
  private_cluster_enabled           = false
  rbac_aad                          = true
  rbac_aad_managed                  = true
  role_based_access_control_enabled = true
  attached_acr_id_map = {
    example = azurerm_container_registry.example.id
  }
  enable_auto_scaling    = false
  enable_host_encryption = false
  brown_field_application_gateway_for_ingress = var.use_brown_field_application_gateway ? {
    id        = azurerm_application_gateway.appgw.id
    subnet_id = azurerm_subnet.appgw.id
  } : null
  create_role_assignments_for_application_gateway = var.create_role_assignments_for_application_gateway
  local_account_disabled                          = false
  net_profile_dns_service_ip                      = "10.0.0.10"
  net_profile_service_cidr                        = "10.0.0.0/16"
  network_plugin                                  = "azure"
  network_policy                                  = "azure"
  os_disk_size_gb                                 = 60
  sku_tier                                        = "Standard"
  vnet_subnet_id                                  = azurerm_subnet.test.id
  depends_on = [
    azurerm_subnet.test,
  ]
}
