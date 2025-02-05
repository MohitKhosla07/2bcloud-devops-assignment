Application Deployment Steps using helm Charts

# Deploy a Web Application based on Node JS 

# Folder Structure
/myapp
  ├── app.js
  ├── package.json
  ├── Dockerfile
  

# app.js

const express = require('express');
const app = express();
const port = 3000;

// Middleware to log requests
app.use((req, res, next) => {
  console.log(`Request received: ${req.method} ${req.url}`);
  next();
});

// Simple "Hello World" route
app.get('/', (req, res) => {
  res.send('Hello World');
});

// Health check endpoint
app.get('/healthz', (req, res) => {      #Health Check for an application endpoint /healthz
  res.status(200).send('Healthy');
});

// Start the server
app.listen(port, () => {
  console.log(`App listening at http://localhost:${port}`);
});


# package.json

{
  "name": "myapp",
  "version": "1.0.0",
  "main": "app.js",
  "dependencies": {
    "express": "^4.17.1"
  }
}


# Step 1.2: Install Dependencies
Run 
npm install

# Dockerfile

# Use the official Node.js image
FROM node:14

# Create and set the working directory
WORKDIR /app

# Copy the application code to the container
COPY . .

# Install dependencies
RUN npm install

# Expose the application port
EXPOSE 3000

# Start the application
CMD ["node", "app.js"]


# STEPS: To Manage these files

#Create a Project Directory

mkdir myapp
cd myapp

#STEP 2 :Create package.json

npm init -y

# STEP 3 : Install Required Dependencies ---Prerequisetes

sudo apt update
sudo apt install -y nodejs npm
npm init -y =  for package.json

npm install express


# Testing on Local

Install Docker on Ubuntu

sudo apt update
sudo apt install -y docker.io

 Start and Enable Docker Service

sudo systemctl start docker
sudo systemctl enable docker

Check if Docker is running:

sudo systemctl status docker

Allow Running Docker Without sudo --not recommended
sudo usermod -aG docker $USER


# BUILD DOCKER IMAGE

docker build -t myapp .


# RUN CONTAINER

docker run -d -p 3000:3000 --name myapp-container myapp

# TEST App

curl http://localhost:3000


# Steps toPush an Image on ACR


az login --service-principal  --username <clientid>  --password <client-secret> --tenant <tenant-id>
az account set --subscription <subscription-id>

#role assignement on ACR -- Prerequisets

az role assignment create \
    --assignee <client-id> \
    --scope <acr-resource-id> \
    --role AcrPush

az role assignment create \
    --assignee <client-id> \
    --scope <acr-resource-id> \
    --role AcrPull


#Login to container registry

az acr login --name <acr-name>


# tag an image

docker tag myapp:latest <acr-name>.azurecr.io/myapp:v1

# push to acr 

docker push <acrname>.azurecr.io/myapp:v1


# Deployment via Helm Charts 

#Prerequisetes

Helm and kubectl must be installed

use - az aks install-cli --install kubelogin

Note-Service principal or user who are deploying an application must have Kubernetes-cluster-write or kubernetes-cluster-admin access

# Deploy to AKS
run commands 
az aks get-credentials --admin --resource-group <rg-name> --name <aks-cluster-name>
helm upgrade --install app <helm-path> --namespace <namespace> --create-namespace --wait --timeout 5m



# TESTING THE APPLICATION RUN:
 http://myapp-k8s-node.eastus2.cloudapp.azure.com/


