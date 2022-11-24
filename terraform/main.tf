resource "proxmox_virtual_environment_download_file" "latest_ubuntu_22_jammy_qcow2_img" {
  content_type       = "import"
  datastore_id       = "local"
  file_name          = "jammy-server-cloudimg-amd64.qcow2"
  node_name          = "hypatia"
  url                = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
  checksum           = "5e3d51211d6e24fa5c6dd1917fd1ec2cae4944813aa25374d3fee12c28530425"
  checksum_algorithm = "sha256"
}

# module "mgmt" {
#   source = "./modules/proxmox-vm"

#   node_name   = "hypatia"
#   vm_name     = "mgmt"
#   vm_id       = 101
#   tags        = ["management"]

#   hostname       = "mgmt"
#   domain         = var.domain
#   ssh_public_key = var.ssh_public_key
#   ip_address     = "192.168.2.110/24"
#   gateway        = "192.168.2.1"

#   cpu_cores    = 2
#   memory_mb    = 4096
#   disk_size_gb = 32

#   cloud_init_template_path = "${path.module}/cloud-init/mgmt.yaml"
#   ubuntu_image_id          = proxmox_virtual_environment_download_file.latest_ubuntu_22_jammy_qcow2_img.id
# }

module "k8s_master_vm" {
  source = "./modules/proxmox-vm"
  count  = var.k8s_cluster_vms["master_count"]

  node_name   = "hypatia"
  vm_name     = "${var.k8s_cluster_vms["cluster_name"]}-master-${count.index + 1}"
  vm_id       = 200 + count.index + 1
  tags        = ["k8s", "control-plane"]

  hostname       = "${var.k8s_cluster_vms["cluster_name"]}-master-${count.index + 1}"
  domain         = var.domain
  ssh_public_key = var.ssh_public_key
  ip_address     = "192.168.2.${200 + count.index}/24"
  gateway        = "192.168.2.1"

  cpu_cores    = 2
  memory_mb    = 4096
  disk_size_gb = 32

  cloud_init_template_path = "${path.module}/cloud-init/k8s.yaml"
  ubuntu_image_id          = proxmox_virtual_environment_download_file.latest_ubuntu_22_jammy_qcow2_img.id
}

module "k8s_worker_vm" {
  source   = "./modules/proxmox-vm"
  for_each = { for idx, worker in var.k8s_cluster_vms.workers : worker.name => worker }

  node_name   = "hypatia"
  vm_name     = "${var.k8s_cluster_vms["cluster_name"]}-${each.value.name}"
  vm_id       = 300 + index(var.k8s_cluster_vms.workers, each.value) + 1
  tags        = ["k8s", "worker"]

  hostname       = "${var.k8s_cluster_vms["cluster_name"]}-${each.value.name}"
  domain         = var.domain
  ssh_public_key = var.ssh_public_key
  ip_address     = "192.168.2.${210 + index(var.k8s_cluster_vms.workers, each.value)}/24"
  gateway        = "192.168.2.1"

  cpu_cores    = each.value.cpu_cores
  memory_mb    = each.value.memory_mb
  disk_size_gb = each.value.disk_size_gb

  cloud_init_template_path = "${path.module}/cloud-init/k8s.yaml"
  ubuntu_image_id          = proxmox_virtual_environment_download_file.latest_ubuntu_22_jammy_qcow2_img.id
}