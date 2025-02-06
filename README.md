# Deploy a Web Application based on Node JS 

# Git commands

# Clone the repository on local
Git clone https://github.com/MohitKhosla07/2bcloud-devops-assignment.git

# Other commands to push changes on repo
1) git add .
   
3) git commit -m "provide a message"
   
5) git push
--will ask for username and token as password


# Step 1: Install Dependencies
Run 
npm install

# STEPS: To Manage these files

Step 1: Create a Project Directory
mkdir myapp
cd myapp

STEP 2 :Create package.json
npm init -y

# STEP 3 : Install Required Dependencies ---Prerequisetes

sudo apt update
sudo apt install -y nodejs npm
npm init -y   --for package.json
npm install express

# Note -  Please run Docker Build command before testing the Application Locally

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

# TEST App

curl http://localhost:3000

# Testing on Local
http:localhost:3000 -- for testing docker file on local
http:localhost:3000/healthz -- for application health check

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

docker tag myapp:latest <acr-name>.azurecr.io/myapp:v1

# Push to ACR

docker push <acrname>.azurecr.io/myapp:v1


# Deployment via Helm Charts 

# Prerequisites

Helm and kubectl must be installed

# Use- az aks install-cli --install kubelogin

# Note-Service principal or user who are deploying an application must have Kubernetes-cluster-write or kubernetes-cluster-admin access

# Deploy to AKS

# login to AKS Cluster
1) az account set --subscription 1eecd364-6e97-42a8-b395-428052081474
   
2) az aks get-crkubelogin convert-kubeconfig -l azurecliedentials --resource-group mohitkhosla-test-devops-assignment-rg --name mohitkhosla-test-aks-cluster --overwrite-existing
   
3) kubelogin convert-kubeconfig -l azurecli

# Check & Run - Kubectl get Pods 

# Run if above command kubectl get pods doesn't work
az aks get-credentials --admin --resource-group <rg-name> --name <aks-cluster-name>


# Create Helm Charts Locally

# Install Kubectl locally
1) sudo snap install kubectl
   
2) sudo snap install kubectl --classic

# Install helm commands
1) sudo apt install snapd
   
2) udo snap install helm --classic
   
3) helm repo add stable https://charts.helm.sh/stable

4) helm repo update
   
5) helm create helm-chart -- Same Helm charts will be created

# Change in values.yaml for desired access

1)enable Autoscaling (HPA)

2) enable resource and limits
   
3) provide replicaCount
   
4) enable ingress
   
5) Install Application gateway Ingress Controller and Provide App gateway DNS Name on Ingress

# Deploy an Application using HELM
helm upgrade --install app <helm-path> --namespace <namespace> --create-namespace --wait --timeout 5m

# TESTING THE APPLICATION RUN:
 http://myapp-k8s-node.eastus2.cloudapp.azure.com/


