#!/bin/bash
set -e

echo "Starting Docker daemon inside the container..."
dockerd &

# Wait until Docker daemon is ready
echo "Waiting for Docker daemon to start..."
while ! docker info > /dev/null 2>&1; do
    sleep 1
done
echo "Docker daemon is ready."

# Create k3d cluster if it doesn't exist
if ! k3d cluster list | grep -q wiki-cluster; then
    k3d cluster create wiki-cluster \
        --servers 1 \
        --agents 1 \
        --servers-memory 2g \
        --agents-memory 1g \
        -p "8080:80@server:0" \
        -p "3000:3000@server:0" \
        --wait
fi

# Export kubeconfig (inside container)
export KUBECONFIG="$(k3d kubeconfig get wiki-cluster)"
echo "KUBECONFIG set to $KUBECONFIG"

# Deploy Helm chart
helm upgrade --install wiki ./wiki-chart -f ./wiki-chart/values.yaml --wait
echo "Helm chart deployed successfully."

# Keep container alive
tail -f /dev/null
