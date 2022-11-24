output "ip_address" {
  description = "The IP address of the VM"
  value       = proxmox_virtual_environment_vm.vm.ipv4_addresses[1][0]
}
