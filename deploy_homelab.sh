#!/bin/bash
set -e 

# Create Homelab VMs
tofu -chdir=terraform apply --auto-approve 

# Wait for VMs to initialize
sleep 60

MASTER_IP=$(tofu -chdir=terraform output -json k8s_master_ips | jq -r '.[0]')
podman build -t k8s-deployer:latest k8s/deploy/
podman run --rm \
    --network host \
    -e MASTER_IP="${MASTER_IP}" \
    -v "${HOME}/.ssh:/root/.ssh:ro" \
    -v "./k8s/kubespray-config:/kubespray/inventory" \
    -v "./argocd:/argocd" \
    k8s-deployer:latest
    