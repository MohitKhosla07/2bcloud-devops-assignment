# 2bcloud-devops-assognment
DevOps Assignment for 2bcloud

# Infrastructure Deployment through Terraform

# Introduction

This is the core repository for Terraform scripts.

# Windows Prerequisites

1. Ensure that you have Administrator rights and you can install any necessary software(s).

# Azure Prerequisites

1. Subscription owner access.
2. AAD read/write permissions to run the scripts.

# Software Prerequisites

Chocoloatey is highly preferred way to work with PowerShell and all tools.
Recommendation is to follow 1st 2 steps from below and then use [Chocolatey Commands](#chocolatey-commands) as mentioned after this section.

Shall you still choose **NOT** to use Chocoloatey, manual links are mentioned from Sr. 3 onwards.

1. PowerShell 7 - Get latest stable release from: https://github.com/PowerShell/PowerShell/releases
2. Chocolatey - Run this command on PowerShell Administrative Prompt: `Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))`
3. Azure CLI - Get latest stable release from: https://github.com/Azure/azure-cli/releases
4. Terraform - Get latest stable release from: https://www.terraform.io/downloads
5. kubectl - Follow guide at: https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/
6. MySQL CLI - Get latest stable release from: https://dev.mysql.com/downloads/shell/
7. Helm Charts - Follow guide at: https://helm.sh/docs/intro/install/

# Chocolatey Commands

1. Azure CLI: `choco install azure-cli`
2. Terraform: `choco install terraform`
3. kubectl: `choco install kubernetes-cli`
4. MySQL CLI: `choco install mysql-cli`
5. Helm: `choco install kubernetes-helm`

# Logging on to Azure

Run command: `az login --tenant c57b960b-9bd2-497d-81bd-c56591f19164`

# Creating Resources (follow the sequence)
- To initialize terraform: 
`terraform init`

- To validate the script:
`terraform validate`

- To make a plan for the environment:
`terraform plan 

- To apply the plan created:
`terraform apply

# Deleting Resources
`terraform destroy 



# Resources Deployed

1. Resource Group
Resource Group Name: mohitkhosla-test-devops-assignment-rg
Location: eastus2

2. Virtual Network
VNet Name: 2bcloud-test-vnet
Address Space: 10.52.0.0/16
Resource Group: mohitkhosla-test-devops-assignment-rg

3. Subnet
Subnet Name: 2bcloud-test-snet
Address Prefix: 10.52.0.0/24
Resource Group: mohitkhosla-test-devops-assignment-rg
Virtual Network: 2bcloud-test-vnet

4. User Assigned Identity
Identity Name: 2bcloud-test-umi
Resource Group: mohitkhosla-test-devops-assignment-rg


5. Log Analytics Workspace
Workspace Name: prefix-workspace
Retention Period: 30 days
SKU: PerGB2018
Resource Group: mohitkhosla-test-devops-assignment-rg

6. Log Analytics Solution (ContainerInsights)
Solution Name: ContainerInsights
Workspace: prefix-workspace

7. Azure Container Registry (ACR)
ACR Name: mohitacrtest
SKU: Standard
Resource Group: mohitkhosla-test-devops-assignment-rg

8. Azure Kubernetes Service (AKS)
An AKS cluster is deployed using the Azure/aks/azurerm module. It is configured to use Azure Active Directory (AAD) authentication, Role-Based Access Control (RBAC), and Log Analytics for monitoring.

Cluster Name: mohitkhosla-test-aks-cluster
Cluster Location: var.location
Node CIDR: 10.1.0.0/16
Admin Username: mohitkhosla07
RBAC AAD Authentication: Enabled
Private Cluster: Disabled
Log Analytics Workspace: prefix-workspace
Container Registry: mohitacrtest
Maintenance Window: Sundays, 22:00–23:00


# Terraform State

Terraform state file is been managed inside a storage account blob container 

resource_group_name  = "test-rg"           # Replace with your resource group name
storage_account_name = "2bcloudtestsa"     # Replace with your storage account name
container_name       = "terraform-state" # Replace with your desired container name
key                  = "terraform.tfstate" # Optional: Specify the filename within the container (defaults to 'terraform.tfstate')

Note: Storage Account "2bcloudtestsa" is manually created on portal to managed statefile configuration on azure

# Terraform Provider

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


azurerm: The azurerm provider is used to interact with Azure resources.
Source: hashicorp/azurerm
Version: >=3.51.0, < 4.0

curl: In this project, it's used for any external HTTP-based interactions required.
Source: anschoewe/curl
Version: 1.0.2

Random: The random provider is used to generate random values that can be used for things like passwords, IDs, and other resources that need to be random.
Source: hashicorp/random
Version: 3.3.2


