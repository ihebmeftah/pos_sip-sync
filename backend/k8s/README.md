# Kubernetes Deployment Guide for Minikube

This guide will help you deploy the POS application to Minikube.

## Prerequisites

1. Install Minikube: https://minikube.sigs.k8s.io/docs/start/
2. Install kubectl: https://kubernetes.io/docs/tasks/tools/
3. Docker Desktop (for Windows)

## Step-by-Step Deployment

### 1. Start Minikube

```bash
minikube start
```

### 2. Configure Docker to use Minikube's Docker daemon

This allows you to build images directly in Minikube:

```bash
# For PowerShell (Windows)
& minikube -p minikube docker-env --shell powershell | Invoke-Expression

# For Bash
eval $(minikube docker-env)
```

### 3. Build the Docker Image

Build your application image inside Minikube:

```bash
docker build -t pos-nestjs-app:latest .
```

### 4. Deploy to Kubernetes

Apply all Kubernetes manifests in order:

```bash
# Create secrets and config
kubectl apply -f k8s/postgres-secret.yaml
kubectl apply -f k8s/app-configmap.yaml

# Create persistent volume claim
kubectl apply -f k8s/postgres-pvc.yaml

# Deploy PostgreSQL
kubectl apply -f k8s/postgres-deployment.yaml
kubectl apply -f k8s/postgres-service.yaml

# Wait for PostgreSQL to be ready
kubectl wait --for=condition=ready pod -l app=postgres --timeout=120s

# Deploy the application
kubectl apply -f k8s/app-deployment.yaml
kubectl apply -f k8s/app-service.yaml
```

Or apply all at once:

```bash
kubectl apply -f k8s/
```

### 5. Verify Deployment

Check if all pods are running:

```bash
kubectl get pods
kubectl get services
kubectl get deployments
```

### 6. Access the Application

Get the Minikube IP and access your app:

```bash
minikube ip
```

Then access your application at: `http://<minikube-ip>:30000`

Or use Minikube's built-in service command:

```bash
minikube service pos-app-service
```

This will automatically open your application in the browser.

### 7. View Logs

```bash
# View app logs
kubectl logs -l app=pos-app

# View postgres logs
kubectl logs -l app=postgres

# Follow logs
kubectl logs -f deployment/pos-app
```

### 8. Scale the Application

```bash
# Scale to 3 replicas
kubectl scale deployment pos-app --replicas=3

# Check status
kubectl get pods
```

## Useful Commands

### Port Forwarding (Alternative Access Method)

```bash
kubectl port-forward service/pos-app-service 3000:3000
```

Then access at: http://localhost:3000

### Execute Commands in Pods

```bash
# Get shell access to app pod
kubectl exec -it <pod-name> -- sh

# Get shell access to postgres pod
kubectl exec -it <postgres-pod-name> -- psql -U admindb -d pos
```

### Update Application

After making code changes:

```bash
# Rebuild image (ensure you're using Minikube's Docker)
eval $(minikube docker-env)
docker build -t pos-nestjs-app:latest .

# Restart deployment
kubectl rollout restart deployment/pos-app
```

### Delete Everything

```bash
kubectl delete -f k8s/
```

Or delete individual resources:

```bash
kubectl delete deployment pos-app
kubectl delete service pos-app-service
kubectl delete deployment postgres
kubectl delete service postgres-service
kubectl delete pvc postgres-pvc
kubectl delete configmap app-config
kubectl delete secret postgres-secret
```

### Stop Minikube

```bash
minikube stop
```

### Delete Minikube Cluster

```bash
minikube delete
```

## Troubleshooting

### Pods not starting?

```bash
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

### Image pull errors?

Make sure you've configured Docker to use Minikube's daemon:

```bash
eval $(minikube docker-env)
docker images  # Should show your images
```

### Can't access the service?

```bash
# Check if service is running
kubectl get svc

# Use minikube service to get the URL
minikube service pos-app-service --url
```

### Database connection issues?

Check if PostgreSQL is ready:

```bash
kubectl get pods -l app=postgres
kubectl logs -l app=postgres
```

## Environment Variables

You can modify environment variables in:

- `k8s/app-configmap.yaml` - For non-sensitive config
- `k8s/postgres-secret.yaml` - For sensitive data (passwords, etc.)

After modifying, apply changes and restart:

```bash
kubectl apply -f k8s/app-configmap.yaml
kubectl rollout restart deployment/pos-app
```
