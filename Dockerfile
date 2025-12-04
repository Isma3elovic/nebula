# Use the Docker-in-Docker base image
FROM docker:stable-dind

# Install required utilities: bash, curl, wget, and clean up afterwards
RUN apk add --no-cache bash curl wget \
    && rm -rf /var/cache/apk/*

# Install Helm
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Install k3d (a lightweight wrapper for k3s in Docker)
RUN wget -q -O /usr/local/bin/k3d https://github.com/k3d-io/k3d/releases/download/v5.6.0/k3d-linux-amd64
RUN chmod +x /usr/local/bin/k3d

# Copy all project artifacts (Part 1 solution components)
# NOTE: These paths must exist in your build context!
COPY wiki-service /app/wiki-service
COPY wiki-chart /app/wiki-chart
COPY start-cluster.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start-cluster.sh

# Expose port 8080, which will be mapped to the k3d Ingress Controller
EXPOSE 8080

# The CMD executes the script to start the cluster and deploy the Helm chart
CMD ["/usr/local/bin/start-cluster.sh"]
