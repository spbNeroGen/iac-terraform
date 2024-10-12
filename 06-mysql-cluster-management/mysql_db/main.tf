terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

variable "database_name" {
  description = "Name of the database to create"
  
    validation {
      condition     = length(var.database_name) > 0
      error_message = "Database name must not be empty."
    }
}

variable "username" {
  description = "Name of the user to create"

    validation {
      condition     = length(var.username) > 0
      error_message = "Username must not be empty."
    }
}

variable "cluster_id" {
  description = "ID of the MySQL cluster"
}

resource "yandex_mdb_mysql_database" "mysql_database" {
  cluster_id = var.cluster_id
  name       = var.database_name
}

resource "yandex_mdb_mysql_user" "mysql_user" {
  cluster_id = var.cluster_id
  name       = var.username
  password   = random_password.password.result

    permission {
      database_name = yandex_mdb_mysql_database.mysql_database.name
      roles         = ["ALL"]
    }
}

resource "random_password" "password" {
  length           = 12
  special          = true
  override_special = "-"
}

output "mysql_database_name" {
  value = yandex_mdb_mysql_database.mysql_database.name
}

output "mysql_user_name" {
  value = yandex_mdb_mysql_user.mysql_user.name
}

output "mysql_user_password" {
  value       = random_password.password.result
  sensitive   = true
}
