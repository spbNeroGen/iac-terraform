## **06-mysql-cluster-management**

- Создание инфраструктуры кластера **MySQL**
    - Модуль для создания кластера управляемой базы данных `MySQL` с поддержкой одного или нескольких хостов.
    - Настройка кластера через ресурс `yandex_mdb_mysql_cluster` с возможностью управления высокодоступностью (HA) через переменную.
    - Модуль для создания базы данных и пользователя в существующем кластере, используя ресурсы `yandex_mdb_mysql_database` и `yandex_mdb_mysql_user`.
    - Добавление базы данных `example-db` и пользователя `user-app` в кластер.
    - Yandex инструкция по [подключению к кластеру](https://yandex.cloud/ru/docs/managed-mysql/operations/connect?from=int-console-help-center-or-nav)
    - Для того чтобы узнать пароль `terraform output mysql_user_password`
---
### Примечание
Провайдер Terraform ограничивает время на выполнение операций с кластером `Managed Service for MySQL`:
- создание кластера, в том числе путем восстановления из резервной копии, — `15 минут`;
- изменение кластера, в том числе обновление версии MySQL, — `60 минут`;
- удаление кластера — `15 минут`.

Операции, длящиеся дольше указанного времени, прерываются.

Необходимо добавить к описанию кластера блок timeouts, например:
```bash
resource "yandex_mdb_mysql_cluster" "<имя_кластера>" {
  ...
  timeouts {
    create = "1h30m" # Полтора часа
    update = "2h"    # 2 часа
    delete = "30m"   # 30 минут
  }
}
```
---