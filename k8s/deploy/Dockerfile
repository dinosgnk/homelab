FROM quay.io/kubespray/kubespray:v2.29.0

# Install required tools
# RUN apt-get update && \
#     apt-get install -y openssh-client curl && \
#     curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
#     install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
#     rm kubectl && \
#     apt-get clean && \
#     rm -rf /var/lib/apt/lists/*

WORKDIR /

# Copy the deployment script
COPY deploy_k8s_cluster.sh .
RUN chmod +x ./deploy_k8s_cluster.sh

# Set entrypoint
ENTRYPOINT ["./deploy_k8s_cluster.sh"]
