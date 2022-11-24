FROM quay.io/kubespray/kubespray:v2.29.0

WORKDIR /kubespray

# Copy the deployment script
COPY deploy_k8s_cluster.sh .
RUN chmod +x ./deploy_k8s_cluster.sh

# Set entrypoint
ENTRYPOINT ["./deploy_k8s_cluster.sh"]
