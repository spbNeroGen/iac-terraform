module "create_vpc" {
  source       = "./create_vpc"
  network_name = "pgsql-network"

  subnets = {
    "zone-a" : {
      zone           = "ru-central1-a"
      v4_cidr_blocks = ["10.1.0.0/16"]
    }
    "zone-b" : {
      zone           = "ru-central1-b"
      v4_cidr_blocks = ["10.2.0.0/16"]
    },
    "zone-d" : {
      zone           = "ru-central1-d"
      v4_cidr_blocks = ["10.3.0.0/16"]
    }
  }
}

module "managed_pgsql" {
  source       = "./create_pgsql"
  cluster_name = "cluster-pgsql"
  network_id   = module.create_vpc.vpc_network_id
  description  = "Cluster PostgreSQL"

    labels = {
        env        = "stage"
        source     = "terraform"
    }

  environment = "PRODUCTION"

  resource_preset_id = "s2.small" #https://yandex.cloud/ru/docs/managed-postgresql/concepts/instance-types
  disk_size          = 10 #GiB

    hosts = [
        {
        zone             = "ru-central1-a",
        subnet_id        = module.create_vpc.subnet_ids_by_names["zone-a"]
        assign_public_ip = false
        },
        {
        zone             = "ru-central1-b",
        subnet_id        = module.create_vpc.subnet_ids_by_names["zone-b"]
        assign_public_ip = false
        },
        {
        zone             = "ru-central1-d",
        subnet_id        = module.create_vpc.subnet_ids_by_names["zone-d"]
        assign_public_ip = false
        }
    ]
    # Дополнительные пользователи
    users = [
        {
        name     = "user1"
        password = ""
        },
        {
        name     = "user2"
        password = "strongpassword"  # Здесь можно задать явный пароль
        },
        {
        name     = "user3"
        password = ""                # Будет сгенерирован автоматически
        }
    ]
    # Дополнительные базы данных
    databases = [
        {
        name  = "db1"
        owner = "user1"
        },
        {
        name  = "db2"
        owner = "user2"
        },
        {
        name  = "db3"
        owner = "user3"
        }
    ]
    depends_on = [module.create_vpc]
}

output "pgsql_cluster_id" {
  description = "ID of the PostgreSQL cluster created by the managed_pgsql module"
  value       = module.managed_pgsql.cluster_id
}

output "pgsql_cluster_name" {
  description = "Name of the PostgreSQL cluster created by the managed_pgsql module"
  value       = module.managed_pgsql.cluster_name
}

output "pgsql_user_ids" {
  description = "List of IDs of the users created in the PostgreSQL cluster"
  value       = module.managed_pgsql.user_ids
}

output "pgsql_database_ids" {
  description = "List of IDs of the databases created in the PostgreSQL cluster"
  value       = module.managed_pgsql.database_ids
}

output "user_passwords" {
  value = module.managed_pgsql.user_passwords
  sensitive = true
}

# Outputs for VPC and subnets
output "vpc_network_id" {
  value = module.create_vpc.vpc_network_id
}

output "subnet_ids_by_zones" {
  value = module.create_vpc.subnet_ids_by_zones
}

output "subnet_ids_by_names" {
  value = module.create_vpc.subnet_ids_by_names
}

output "subnet_v4_blocks_by_zones" {
  value = module.create_vpc.subnet_v4_blocks_by_zones
}