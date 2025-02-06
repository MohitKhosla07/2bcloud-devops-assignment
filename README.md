Application Deployment Steps using helm Charts

# Deploy a Web Application based on Node JS 

# Prerequisites

# Git commands

# Clone the repository on local
Git clone https://github.com/MohitKhosla07/2bcloud-devops-assignment.git

make changes locally or add new files or update files

# other commands to push changes on repo
git add .
git commit -m "provide a message"
git push
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

# login to azure cloud via SP
az login --service-principal  --username <clientid>  --password <client-secret> --tenant <tenant-id>
az account set --subscription <subscription-id>

# role assignement on ACR -- Prerequisites

# ACR PUSH Access to Push Docker Image

az role assignment create \
    --assignee <client-id> \
    --scope <acr-resource-id> \
    --role AcrPush

# ACR Pull access to pull image from acr on aks

az role assignment create \
    --assignee <client-id> \
    --scope <acr-resource-id> \
    --role AcrPull


# Login to container registry

az acr login --name <acr-name>

# tag an image

docker tag myapp:latest <acr-name>.azurecr.io/myapp:v1

# push to acr 

docker push <acrname>.azurecr.io/myapp:v1


# Deployment via Helm Charts 

# Prerequisites

Helm and kubectl must be installed

# use - az aks install-cli --install kubelogin

# Note-Service principal or user who are deploying an application must have Kubernetes-cluster-write or kubernetes-cluster-admin access

# Deploy to AKS
az aks get-credentials --admin --resource-group <rg-name> --name <aks-cluster-name>
helm upgrade --install app <helm-path> --namespace <namespace> --create-namespace --wait --timeout 5m

# Create Helm Charts Locally
# Install Kubectl locally
sudo snap install kubectl
sudo snap install kubectl --classic

# Install helm commands
sudo apt install snapd
sudo snap install helm --classic
helm repo add stable https://charts.helm.sh/stable
helm repo update
helm create helm-chart -- Same Helm charts will be created

# make changes in values.yaml for desired access

enable Autoscaling (HPA)
enable resource and limits
provide replicaCount
enable ingress
Install Application gateway Ingress Controller and Provide App gateway DNS Name on Ingress

# TESTING THE APPLICATION RUN:
 http://myapp-k8s-node.eastus2.cloudapp.azure.com/


