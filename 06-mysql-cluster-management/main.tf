resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}

module "mysql_cluster" {
  source       = "./mysql_cluster"
  cluster_name = "example-cluster-mysql"
  network_id   = yandex_vpc_network.develop.id
  ha_enabled   = true  # false-1 true-2 = количество хостов
  zone_and_cidr_blocks = {
    "zone1" = {
      zone           = "ru-central1-a"
      v4_cidr_blocks = ["10.0.1.0/24"]
    },
    "zone2" = {
      zone           = "ru-central1-b"
      v4_cidr_blocks = ["10.0.2.0/24"]
    }
  }
  }

module "mysql_database_and_user" {
  source      = "./mysql_db"
  database_name = "example-db"
  username     = "user-app"
  cluster_id   = module.mysql_cluster.cluster_id
}

# Выводим ID кластера MySQL
output "mysql_cluster_id" {
  value = module.mysql_cluster.cluster_id
}

# Выводим IP-адреса хостов кластера MySQL
output "mysql_cluster_host_ips" {
  value = module.mysql_cluster.cluster_host_ips
}

# Выводим имя созданной базы данных MySQL
output "mysql_database_name" {
  value = module.mysql_database_and_user.mysql_database_name
}

# Выводим имя пользователя MySQL
output "mysql_user_name" {
  value = module.mysql_database_and_user.mysql_user_name
}

# Выводим сгенерированный пароль пользователя MySQL (чувствительный)
output "mysql_user_password" {
  value     = module.mysql_database_and_user.mysql_user_password
  sensitive = true
}
