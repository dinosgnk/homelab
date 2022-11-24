output "k8s_master_ips" {
  value = [for master in module.k8s_master_vm : master.ip_address]
}

output "k8s_worker_ips" {
  value = [for worker in module.k8s_worker_vm : worker.ip_address]
}