#!/bin/bash
set -e

echo "Starting k3d cluster..."
# Create the k3d cluster and map container port 8080 to the Ingress controller's port
k3d cluster create my-cluster --port 8080:80@loadbalancer --wait

# 1. Build and Load the FastAPI image into the k3d cluster
echo "Building and loading wiki-service image..."
docker build -t my-wiki-service-image:latest /app/wiki-service
k3d image import my-wiki-service-image:latest -c my-cluster

# 2. Deploy the Helm Chart (Part 1 solution)
echo "Deploying wiki-chart via Helm..."
helm upgrade --install wiki-release /app/wiki-chart \
  --set fastapiImage.repository=my-wiki-service-image \
  --set fastapiImage.tag=latest \
  --timeout 10m

# 3. Wait for all resources to be ready
echo "Waiting for all deployments to be ready..."
kubectl wait --for=condition=ready pod --all --timeout=5m

# 4. Keep the container alive for external access
echo "Cluster is running and services are ready. Press Ctrl+C to stop."
tail -f /dev/null
