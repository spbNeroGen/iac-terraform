resource "yandex_compute_disk" "secondary-disk" {
  count = 3
  name = "disk-${count.index+1}"
  size = 1
  type = "network-hdd"
  zone = var.default_zone
}

resource "yandex_compute_instance" "vm_storage" {
  name        = "storage"
  folder_id   = var.folder_id
  zone        = var.default_zone
  platform_id = var.platform_id
  depends_on = [yandex_compute_instance.vm-db]

    resources {
      cores = var.vm_storage_cores
      memory = var.vm_storage_memory
      core_fraction = var.vm_storage_core_fraction
    }

    boot_disk {
      initialize_params {
        image_id = data.yandex_compute_image.ubuntu.id
      }
    }

    dynamic "secondary_disk" {
      for_each = yandex_compute_disk.secondary-disk.*.id

      content {
        auto_delete = true
        disk_id     = secondary_disk.value
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
