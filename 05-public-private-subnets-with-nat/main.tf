resource "yandex_compute_instance" "nat-instance" {
  name     = "nat-instance"
  hostname = "nat-instance"
  platform_id = "standard-v2"
  zone     = var.default_zone

    resources {
      cores         = var.vm_base.cores
      memory        = var.vm_base.memory
      core_fraction = var.vm_base.core_fraction
    }

    boot_disk {
      initialize_params {
        image_id    = var.nat-instance-image-id
        size        = var.vm_base.disk_size
      }
    }

    scheduling_policy {
      preemptible = true
    }

    network_interface {
      subnet_id  = yandex_vpc_subnet.public.id
      ip_address = var.nat-instance-ip
      nat        = true
    }

    metadata = local.ssh_keys_and_serial_port

}

resource "yandex_compute_instance" "public_vm" {
  name        = "public-vm"
  hostname    = "public-vm"
  platform_id = "standard-v2"

    resources {
      cores         = var.vm_base.cores
      memory        = var.vm_base.memory
      core_fraction = var.vm_base.core_fraction
    }

    boot_disk {
      initialize_params {
        image_id = var.vm_base.image_id
        size     = var.vm_base.disk_size
      }
    }

    scheduling_policy {
      preemptible = true
    }

    network_interface {
      subnet_id = yandex_vpc_subnet.public.id
      nat       = true
    }

    metadata = local.ssh_keys_and_serial_port
}

resource "yandex_compute_instance" "private_vm" {
  name        = "private-vm"
  hostname    = "private-vm"
  platform_id = "standard-v2"

  resources {
    cores         = var.vm_base.cores
    memory        = var.vm_base.memory
    core_fraction = var.vm_base.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.vm_base.image_id
      size     = var.vm_base.disk_size
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.private.id
    nat       = false
  }

  metadata = local.ssh_keys_and_serial_port
}
