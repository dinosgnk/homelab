variable "node_name" {
  description = "Proxmox node name"
  type        = string
}

variable "vm_name" {
  description = "Name of the VM"
  type        = string
}

variable "vm_id" {
  description = "VM ID"
  type        = number
}

variable "description" {
  description = "VM description"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags for the VM"
  type        = list(string)
  default     = []
}

variable "hostname" {
  description = "Hostname for cloud-init"
  type        = string
}

variable "domain" {
  description = "Domain name"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key"
  type        = string
}

variable "ip_address" {
  description = "IP address with CIDR notation (e.g., 192.168.2.200/24)"
  type        = string
}

variable "gateway" {
  description = "Network gateway"
  type        = string
  default     = "192.168.2.1"
}

variable "cpu_cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 2
}

variable "memory_mb" {
  description = "Memory in MB"
  type        = number
  default     = 4096
}

variable "disk_size_gb" {
  description = "Disk size in GB"
  type        = number
  default     = 32
}

variable "datastore_id" {
  description = "Datastore ID for VM disks"
  type        = string
  default     = "vm-data"
}

variable "cloud_init_datastore_id" {
  description = "Datastore ID for cloud-init snippets"
  type        = string
  default     = "local"
}

variable "cloud_init_template_path" {
  description = "Path to cloud-init template file"
  type        = string
}

variable "ubuntu_image_id" {
  description = "ID of the Ubuntu image to use"
  type        = string
}

variable "network_bridge" {
  description = "Network bridge to use"
  type        = string
  default     = "vmbr0"
}

variable "dns_servers" {
  description = "List of DNS servers"
  type        = list(string)
  default     = []
}
