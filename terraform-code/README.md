# Infrastructure Deployment Using Terraform

## Introduction
This repository contains Terraform scripts for provisioning infrastructure on Azure.

## Prerequisites
### Windows Requirements
1. Administrator rights to install required software.

### Azure Requirements
1. Subscription owner access.
2. Azure Active Directory (AAD) read/write permissions.

### Software Requirements
Using Chocolatey is the recommended approach for installing required tools via PowerShell.
If you prefer manual installation, links are provided below.

1. **PowerShell 7** - [Download](https://github.com/PowerShell/PowerShell/releases)
2. **Chocolatey** - Install via PowerShell (Admin):
   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force;
   [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
   iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
   ```
3. **Azure CLI** - [Download](https://github.com/Azure/azure-cli/releases)
4. **Terraform** - [Download](https://www.terraform.io/downloads)
5. **kubectl** - [Install Guide](https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/)
6. **MySQL CLI** - [Download](https://dev.mysql.com/downloads/shell/)
7. **Helm** - [Install Guide](https://helm.sh/docs/intro/install/)

### Chocolatey Commands for Installation
```powershell
choco install azure-cli
choco install terraform
choco install kubernetes-cli
choco install mysql-cli
choco install kubernetes-helm
```

## Logging in to Azure
```powershell
az login --tenant <your-tenant-id>
```

## Deploying Resources with Terraform
1. Initialize Terraform:
   ```powershell
   terraform init
   ```
2. Validate the script:
   ```powershell
   terraform validate
   ```
3. Create a plan for the environment:
   ```powershell
   terraform plan
   ```
4. Apply the plan:
   ```powershell
   terraform apply
   ```

## Deleting Resources
```powershell
terraform destroy
```

## Resources Deployed
1. **Resource Group**
   - Name: `<resource-group-name>`
   - Location: `<region>`

2. **Virtual Network**
   - Name: `<vnet-name>`
   - Address Space: `10.52.0.0/16`
   - Resource Group: `<resource-group-name>`

3. **Subnet**
   - Name: `<subnet-name>`
   - Address Prefix: `10.52.0.0/24`
   - Virtual Network: `<vnet-name>`

4. **User Assigned Identity**
   - Name: `<identity-name>`

5. **Log Analytics Workspace**
   - Name: `<workspace-name>`
   - Retention Period: `30 days`
   - SKU: `PerGB2018`

6. **Azure Container Registry (ACR)**
   - Name: `<acr-name>`
   - SKU: `Standard`

7. **Azure Kubernetes Service (AKS)**
   - Cluster Name: `<aks-cluster-name>`
   - Node CIDR: `10.1.0.0/16`
   - RBAC AAD Authentication: Enabled
   - Private Cluster: Disabled
   - Log Analytics Workspace: `<workspace-name>`
   - Container Registry: `<acr-name>`

8. **Azure Application Gateway (App Gateway)**
   - Name: `<app-gateway-name>`
   - SKU: `Standard_V2`
   - Frontend IP: Public
   - Auto-scaling: Enabled (Min: `2 instances`)
   - Web Application Firewall (WAF): Enabled

## Terraform State Management
Terraform state is stored in an Azure Storage Account Blob container:
```hcl
resource_group_name  = "<resource-group-name>"
storage_account_name = "<storage-account-name>"
container_name       = "terraform-state"
key                  = "terraform.tfstate"
```
_**Note:** Ensure that the storage account is manually created in Azure before using it for state management._

### Provider Details
- **azurerm**: Manages Azure resources.
- **curl**: Handles external HTTP interactions.
- **random**: Generates random values for unique resource names.

