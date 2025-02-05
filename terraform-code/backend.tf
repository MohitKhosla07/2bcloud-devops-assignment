terraform {
  backend "azurerm" {
    resource_group_name  = "test-rg"           # Replace with your resource group name
    storage_account_name = "2bcloudtestsa"     # Replace with your storage account name
    container_name       = "terraform-state" # Replace with your desired container name
    key                  = "terraform.tfstate" # Optional: Specify the filename within the container (defaults to 'terraform.tfstate')

  }
}
