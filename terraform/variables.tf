variable "proxmox" {
  description = "Proxmox provider configuration"
  type = object({
    name         = string
    cluster_name = string
    endpoint     = string
    insecure     = bool
    username     = string
  })
}

variable "proxmox_api_token" {
  description = "API token for Proxmox"
  type        = string
  sensitive   = true
}

variable "domain" {
  description = "Domain name for the VMs"
  type        = string
  default     = "homelab.local"
}

variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
}

variable "k8s_cluster_vms" {
  type = object({
    cluster_name = string
    master_count = number
    workers = list(object({
      name         = string
      disk_size_gb = number
      cpu_cores    = optional(number, 2)
      memory_mb    = optional(number, 4096)
      node_name    = optional(string, "hypatia")
    }))
  })
}