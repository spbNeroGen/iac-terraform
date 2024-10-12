resource "yandex_compute_instance" "vm-web" {
  count       = 2
  name        = "web-${count.index + 1}" # Счет начинается с 0, добавляем 1
  folder_id   = var.folder_id
  zone        = var.default_zone
  platform_id = var.platform_id
  depends_on = [yandex_compute_instance.vm-db] 

    resources {
      cores = var.vm_web_cores
      memory = var.vm_web_memory
      core_fraction = var.vm_web_core_fraction
    }

    boot_disk {
      initialize_params {
        image_id = data.yandex_compute_image.ubuntu.id
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
