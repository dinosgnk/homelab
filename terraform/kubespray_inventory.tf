locals {
  # Convert master IP list into a hostname→IP map
  master_map = {
    for idx, master in module.k8s_master_vm :
    "${var.k8s_cluster_vms.cluster_name}-master-${idx + 1}" => master.ip_address
  }

  # Convert worker IP map into a hostname→IP map
  worker_map = {
    for name, worker in module.k8s_worker_vm :
    "${var.k8s_cluster_vms.cluster_name}-${name}" => worker.ip_address
  }

  # Merge all hosts into one map
  all_hosts = merge(local.master_map, local.worker_map)
}

# Render inventory with templatefile()
resource "local_file" "kubespray_inventory" {
  filename = "${path.module}/../k8s/kubespray-config/hyperion-cluster/hosts.yaml"

  content = templatefile("${path.module}/templates/inventory.tpl", {
    hosts   = local.all_hosts
    masters = local.master_map
    workers = local.worker_map
  })
}