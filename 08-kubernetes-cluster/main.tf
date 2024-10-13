# Create kubernatis cluster
resource "yandex_kubernetes_cluster" "kuber-cluster" { #https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_cluster

  name       = "kuber-cluster"
  network_id = yandex_vpc_network.main-network.id

  master {
    regional {
      region = "ru-central1"

      location {
        zone      = yandex_vpc_subnet.internal-a.zone
        subnet_id = yandex_vpc_subnet.internal-a.id
      }

      location {
        zone      = yandex_vpc_subnet.internal-b.zone
        subnet_id = yandex_vpc_subnet.internal-b.id
      }

      location {
        zone      = yandex_vpc_subnet.internal-d.zone
        subnet_id = yandex_vpc_subnet.internal-d.id
      }
    }
    
    version   = "1.29"
    public_ip = true
    
  }

  release_channel = "STABLE" #https://yandex.cloud/ru/docs/managed-kubernetes/concepts/release-channels-and-updates
  
  service_account_id      = yandex_iam_service_account.sa-cluster.id
  node_service_account_id = yandex_iam_service_account.sa-cluster.id

  depends_on = [
    yandex_resourcemanager_folder_iam_member.k8s-clusters-agent,
    yandex_resourcemanager_folder_iam_member.vpc-public-admin,
    yandex_resourcemanager_folder_iam_member.images-puller,
    yandex_resourcemanager_folder_iam_binding.vm-editor-role,
    yandex_resourcemanager_folder_iam_binding.images-pusher,
    yandex_resourcemanager_folder_iam_member.encrypterDecrypter
  ]

  kms_provider {
    key_id = yandex_kms_symmetric_key.kms-key.id
  }
  
  labels = {
    my_key       = "my_value"
    my_other_key = "my_other_value"
  }
}

resource "yandex_kubernetes_node_group" "nodes-group" {
  cluster_id  = yandex_kubernetes_cluster.kuber-cluster.id
  name        = "nodes-group"
  version     = "1.29"

  instance_template {
    platform_id = "standard-v2"

    network_interface {
      nat        = true
      subnet_ids = ["${yandex_vpc_subnet.internal-a.id}", "${yandex_vpc_subnet.internal-b.id}", "${yandex_vpc_subnet.internal-d.id}"]
    }

    resources {
      core_fraction = 20
      memory        = 2
      cores         = 2
    }

    boot_disk {
      type = "network-ssd"
      size = 64
    }

    scheduling_policy {
      preemptible = false
    }
  }

    scale_policy {
        fixed_scale {
        size = 3
        }
    }

  allocation_policy {
    location {
      zone = "ru-central1-a"
    }

    location {
      zone = "ru-central1-b"
    }

    location {
      zone = "ru-central1-d"
    }
  }

  maintenance_policy {
    auto_upgrade = false
    auto_repair  = true
  }

  depends_on = [
    yandex_kubernetes_cluster.kuber-cluster
  ]
}