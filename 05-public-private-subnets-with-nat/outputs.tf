output "public-vm" {
  value = "${yandex_compute_instance.public_vm.name} - ${yandex_compute_instance.public_vm.network_interface.0.ip_address}(${yandex_compute_instance.public_vm.network_interface.0.nat_ip_address})"
  description = "Публичная ВМ"
}

output "private-vm" {
  value = "${yandex_compute_instance.private_vm.name} - ${yandex_compute_instance.private_vm.network_interface.0.ip_address}(${yandex_compute_instance.private_vm.network_interface.0.nat_ip_address})"
  description = "Приватная ВМ"
}

output "nat_instance" {
  value = "${yandex_compute_instance.nat-instance.name} - ${yandex_compute_instance.nat-instance.network_interface.0.ip_address}(${yandex_compute_instance.nat-instance.network_interface.0.nat_ip_address})"
  description = "NAT инстанс" 
}
