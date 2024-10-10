output "vm_public_ip" {
  description = "Public IP of the compute instance"
  value       = yandex_compute_instance.simple-vm.network_interface[0].nat_ip_address
}

output "vm_name" {
  description = "Name of the compute instance"
  value       = yandex_compute_instance.simple-vm.name
}

output "vm_ssh_access" {
  description = "SSH command to access the VM"
  value       = "ssh nerogen@${yandex_compute_instance.simple-vm.network_interface[0].nat_ip_address}"
}

output "vm_id" {
  description = "ID of the compute instance"
  value       = yandex_compute_instance.simple-vm.id
}
