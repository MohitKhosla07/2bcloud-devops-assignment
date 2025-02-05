data "azurerm_client_config" "example" {}


terraform {
  required_version = ">=1.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.51.0, < 4.0"
    }
    curl = {
      source  = "anschoewe/curl"
      version = "1.0.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.3.2"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy       = false
      purge_soft_deleted_keys_on_destroy = false
      recover_soft_deleted_key_vaults    = false
    }
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  client_id       = data.azurerm_client_config.example.client_id
  client_secret   = data.azurerm_client_config.example.client_secret
  tenant_id       = data.azurerm_client_config.example.tenant_id
  subscription_id = data.azurerm_client_config.example.subscription_id
}

provider "curl" {}

provider "random" {}
