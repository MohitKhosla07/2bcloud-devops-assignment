# Deploy a Web Application based on Node JS 

# Steps to Install Docker Locally 
sudo apt update
sudo apt install -y docker.io

# Start and Enable Docker Service
sudo systemctl start docker
sudo systemctl enable docker

# Check if Docker is running:
sudo systemctl status docker

# Allow Running Docker Without sudo --not recommended
sudo usermod -aG docker $USER

# BUILD DOCKER IMAGE
docker build -t myapp .

# RUN CONTAINER
docker run -d -p 3000:3000 --name myapp-container myapp

# Testing on Local
http://localhost:3000 -- for testing docker file on local
http://localhost:3000/healthz -- for application health check

# Steps to Push an Image on ACR
docker push 2bcloudtestacr.azurecr.io/<image-name>:<version>

# Login to Azure Cloud via SP
az login --service-principal  --username <clientid>  --password <client-secret> --tenant <tenant-id>
az account set --subscription <subscription-id>

# Role Assignment on ACR -- Prerequisites

# ACR PUSH Access to Push Docker Image

az role assignment create \
    --assignee <client-id> \
    --scope <acr-resource-id> \
    --role AcrPush

# ACR Pull access to pull image from acr on AKS

az role assignment create \
    --assignee <client-id> \
    --scope <acr-resource-id> \
    --role AcrPull


# Login to Azure Container Registry
az acr login --name <acr-name>

# Tag an Image
docker tag myapp:latest acr-name.azurecr.io/repo:version

# Push to ACR
docker push <acrname>.azurecr.io/repo:version


# Deployment via Helm Charts 

# Prerequisites
Helm and kubectl must be installed

# Note-Service principal or user who are deploying an application must have Kubernetes-cluster-write or kubernetes-cluster-admin access

# Deploy to AKS

# login to AKS Cluster
1) az account set --subscription <subscription-id>
   
2) az aks get-crkubelogin convert-kubeconfig -l azurecliedentials --resource-group <rg-name>--name <aks-cluster-name> --overwrite-existing
   
3) kubelogin convert-kubeconfig -l azurecli

# Check & Run - Kubectl get Pods 

# Run if above command kubectl get pods doesn't work
az aks get-credentials --admin --resource-group <rg-name> --name <aks-cluster-name>


# Install kubelogin and kubctl
az aks install-cli

# Install Helm 
http://helm.sh/docs/intro/install/

# HELM DEPLOYMENT

# Change in values.yaml for desired access
1) Image - repository: acr-name.azurecr.io/repo

2) enable Autoscaling (HPA)

3) enable resource and limits
   
4) provide replicaCount
   
5) enable ingress
   
6) Install Application gateway Ingress Controller and Provide App gateway DNS Name on Ingress

# Enable Addons

$appgwId = $(az network application-gateway show -n ingress -g <rg-name>-o tsv --query "id")
az aks enable-addons -n <your-aks-cluster-name> -g <aks-rg-name> --addons ingress-appgw --appgw-id $appgwId

# Deploy an Application using HELM
helm upgrade --install app <helm-path> --namespace <namespace> --create-namespace --wait --timeout 5m

# TESTING THE APPLICATION RUN:
 http://myapp-k8s-node.eastus2.cloudapp.azure.com/


