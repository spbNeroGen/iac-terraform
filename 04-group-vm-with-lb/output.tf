output "vms_public_ip" {
  description = "Public IP of the compute instance"
  value       = yandex_compute_instance.group-vms[*].network_interface[0].nat_ip_address
}

output "vms_ssh_access" {
  description = "SSH command to access the VM"
  value       = "ssh ubuntu@${yandex_compute_instance.group-vms[*].network_interface[0].nat_ip_address}"
}

output "vms_name" {
  description = "Name of the compute instance"
  value       = yandex_compute_instance.group-vms[*].name
}

output "lb_ip_address" {
  value = yandex_lb_network_load_balancer.lb-network.listener.*.external_address_spec[0].*.address
}

