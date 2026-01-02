locals {
  datastore_id = "vm-data-${var.node_name}"
}

resource "proxmox_virtual_environment_file" "cloud_init" {
  node_name    = var.node_name
  datastore_id = var.cloud_init_datastore_id
  content_type = "snippets"
  
  source_raw {
    data = templatefile(var.cloud_init_template_path, {
      hostname = var.hostname
      domain   = var.domain
      ssh_key  = var.ssh_public_key
    })
    file_name = "cloud-init-${var.vm_name}.yaml"
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  node_name = var.node_name
  
  name        = var.vm_name
  description = var.description
  tags        = var.tags
  vm_id       = var.vm_id

  machine       = "q35"
  scsi_hardware = "virtio-scsi-single"
  bios          = "ovmf"

  agent {
    enabled = true
    timeout = "180s"
  }

  cpu {
    cores = var.cpu_cores
    type  = "host"
  }

  memory {
    dedicated = var.memory_mb
  }

  efi_disk {
    datastore_id = local.datastore_id
    file_format  = "raw"
    type         = "4m"
  }

  disk {
    datastore_id = local.datastore_id
    import_from  = var.ubuntu_image_id
    interface    = "scsi0"
    cache        = "none"
    discard      = "on"
    ssd          = true
    size         = var.disk_size_gb
  }

  network_device {
    bridge = var.network_bridge
  }

  operating_system {
    type = "l26"
  }

  initialization {
    ip_config {
      ipv4 {
        address = var.ip_address
        gateway = var.gateway
      }
    }

    datastore_id      = local.datastore_id
    user_data_file_id = proxmox_virtual_environment_file.cloud_init.id
  }
}
