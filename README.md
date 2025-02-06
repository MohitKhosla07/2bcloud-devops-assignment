# Deploy a Web Application Based on Node.js

## Steps to Install Docker Locally

```sh
sudo apt update
sudo apt install -y docker.io
```

### Start and Enable Docker Service
```sh
sudo systemctl start docker
sudo systemctl enable docker
```

### Check if Docker is Running
```sh
sudo systemctl status docker
```

### Allow Running Docker Without `sudo` *(Not Recommended)*
```sh
sudo usermod -aG docker $USER
```

## Build and Run the Docker Image

### Build Docker Image
```sh
docker build -t myapp .
```

### Run Container
```sh
docker run -d -p 3000:3000 --name myapp-container myapp
```

### Testing Locally
- **Test the application:** `http://localhost:3000`
- **Health Check:** `http://localhost:3000/healthz`

---

## Steps to Push an Image to Azure Container Registry (ACR)

### Push Image to ACR
```sh
docker push 2bcloudtestacr.azurecr.io/<image-name>:<version>
```

### Login to Azure Cloud via Service Principal (SP)
```sh
az login --service-principal  --username <clientid>  --password <client-secret> --tenant <tenant-id>
az account set --subscription <subscription-id>
```

### Assign Roles for ACR Access

#### ACR Push Access (to push images)
```sh
az role assignment create \
    --assignee <client-id> \
    --scope <acr-resource-id> \
    --role AcrPush
```

#### ACR Pull Access (to pull images from ACR on AKS)
```sh
az role assignment create \
    --assignee <client-id> \
    --scope <acr-resource-id> \
    --role AcrPull
```

### Login to Azure Container Registry
```sh
az acr login --name <acr-name>
```

### Tag and Push Image to ACR
```sh
docker tag myapp:latest <acr-name>.azurecr.io/repo:version
docker push <acr-name>.azurecr.io/repo:version
```

---

## Deployment via Helm Charts

### Prerequisites
- **Helm and kubectl must be installed**
- **Service Principal/User must have** `Kubernetes-cluster-write` **or** `Kubernetes-cluster-admin` **access**

### Login to AKS Cluster
```sh
az account set --subscription <subscription-id>
az aks get-credentials --resource-group <rg-name> --name <aks-cluster-name> --overwrite-existing
kubelogin convert-kubeconfig -l azurecli
```

### Verify Cluster Access
```sh
kubectl get pods
```

*(If the above command fails, run:)*
```sh
az aks get-credentials --admin --resource-group <rg-name> --name <aks-cluster-name>
```

### Install Required CLI Tools
```sh
az aks install-cli  # Installs kubelogin and kubectl
```

### Install Helm
Follow official Helm installation guide: [Helm Install](http://helm.sh/docs/intro/install/)

### Configure Helm Deployment
Edit `values.yaml` to update the following parameters:
1. **Image Repository** - `repository: <acr-name>.azurecr.io/repo`
2. **Enable Autoscaling (HPA)**
3. **Configure Resource Requests and Limits**
4. **Set Replica Count**
5. **Enable Ingress Controller**
6. **Install Application Gateway Ingress Controller and Set App Gateway DNS Name**

### Enable Addons
```sh
$appgwId=$(az network application-gateway show -n ingress -g <rg-name> -o tsv --query "id")
az aks enable-addons -n <aks-cluster-name> -g <aks-rg-name> --addons ingress-appgw --appgw-id $appgwId
```

### Deploy Application Using Helm
```sh
helm upgrade --install app <helm-path> --namespace <namespace> --create-namespace --wait --timeout 5m
```

---

## Testing the Application
Access the application at:
```sh
http://myapp-k8s-node.eastus2.cloudapp.azure.com/
```

