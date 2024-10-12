

resource "yandex_compute_instance" "vm-db" {
  # Преобразование списка объектов в словарь с ключами, основанными на vm_name
  for_each = { for vm in var.each_vm : vm.vm_name => vm }
  depends_on = [yandex_vpc_subnet.main-network-subnet]
  name        = each.value.vm_name
  folder_id   = var.folder_id
  zone        = var.default_zone
  platform_id = var.platform_id

    resources {
      cores  = each.value.cpu
      memory = each.value.ram
      core_fraction = each.value.core_fraction
    }

    boot_disk {
      initialize_params {
        image_id = data.yandex_compute_image.ubuntu.id
        size     = each.value.disk_volume
      }
    }

    network_interface {
      
      subnet_id = yandex_vpc_subnet.main-network-subnet.id
      nat       = true
      // Группа безопасности
      security_group_ids = [yandex_vpc_security_group.security-group.id]
    }

    metadata = {
        ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
    }
}
