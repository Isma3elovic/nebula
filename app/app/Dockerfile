# Use a suitable base image for running Docker/k3d
FROM docker:stable-dind 
# 'dind' stands for Docker-in-Docker and is often a good starting point.

# Install necessary tools: Helm and k3d
RUN apk add --no-cache curl bash 
# Install Helm
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
# Install k3d
RUN wget -q -O /usr/local/bin/k3d https://github.com/k3d-io/k3d/releases/download/v5.6.0/k3d-linux-amd64
RUN chmod +x /usr/local/bin/k3d

# Copy all project files
COPY wiki-service /app/wiki-service
COPY wiki-chart /app/wiki-chart
COPY start-cluster.sh /usr/local/bin/start-cluster.sh
RUN chmod +x /usr/local/bin/start-cluster.sh

# Expose the required port (8080) for external access
EXPOSE 8080

# Set the entrypoint to the script
CMD ["/usr/local/bin/start-cluster.sh"]
