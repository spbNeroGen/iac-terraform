# **09-postgresql-cluster-management**
- Создание кластера management базы данных **PostgreSQL**
    - Модуль для создания кластера с использованием ресурса `yandex_mdb_postgresql_cluster`.
    - Включение одной или нескольких реплик через переменную `hosts`, которая принимает список зон и параметров сетевого подключения.
    - Настройка пользователей и баз данных с помощью ресурсов `yandex_mdb_postgresql_user` и `yandex_mdb_postgresql_database`, включая возможность автоматической генерации паролей.
    - Определение переменных для управления пользователями, их паролями и базами данных, которые будут созданы в кластере.
    - Вывод паролей созданных пользователей и информации о базах данных через выходные данные модуля `terraform output user_passwords`
    - Yandex инструкция по [подключению к кластеру](https://yandex.cloud/ru/docs/managed-postgresql/operations/connect) и [созданию кластера](https://yandex.cloud/ru/docs/managed-postgresql/operations/cluster-create)

#### Пример переменных:
```hcl
variable "users" {
  type = list(object({
    name     = string
    password = string
  }))
  default = [
    {
      name     = "user1"
      password = ""
    },
    {
      name     = "user2"
      password = "secure_password" # Укажите пароль для второго пользователя
    }
  ]
}

variable "databases" {
  type = list(object({
    name  = string
    owner = string
  }))
  default = [
    {
      name  = "db1"
      owner = "user1"
    },
    {
      name  = "db2"
      owner = "user2"
    }
  ]
}
```