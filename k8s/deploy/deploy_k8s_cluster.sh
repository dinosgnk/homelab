#!/bin/bash
set -e

# Create K8s Cluster using Kubespray
ansible-playbook -i inventory/hyperion-cluster/hosts.yaml cluster.yml

# Wait for cluster to stabilize
sleep 30

# Get Kubeconfig from Master Node
mkdir -p ~/.kube
ssh -o StrictHostKeyChecking=no labadmin@${MASTER_IP} "sudo cat /root/.kube/config" > ~/.kube/config
sed -i "s|https://127.0.0.1:6443|https://${MASTER_IP}:6443|g" ~/.kube/config

# Install ArgoCD Bootstrap Application
kubectl apply -f /argocd/bootstrap/root-application.yaml