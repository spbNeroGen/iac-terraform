# Infrastructure as Code with Terraform

## Описание

Целью репозитория является демонстрация практического применения подхода **Infrastructure as Code (IaC)** для управления облачными ресурсами. Все проекты нацелены на создание, управление и настройку различных компонентов инфраструктуры в облачной среде **Yandex Cloud**.

## Структура репозитория
- **[01-bucket-sa](./01-bucket-sa/)** - создает **Service Account** и **бакет Object Storage**
- **[02-simple-vm](./02-simple-vm/)** - создает виртуальную машину в **default сети** с **2CPU**, **4Gb** оперативной памяти
- **[03-simple-vm-cloud-init](./03-simple-vm-cloud-init/)** - создает виртуальную машину с использованием **cloud-init** для автоматической настройки системы.

## Используемый стек
- **Terraform** — инструмент для управления инфраструктурой как кодом.
- **Yandex Cloud** — облачная платформа, используемая для развертывания ресурсов.
- **Yandex Cloud CLI** — для аутентификации и управления ресурсами через командную строку.

## Предварительные требования
1. Аккаунт в Yandex Cloud.
2. Установленный [Terraform](https://yandex.cloud/ru/docs/tutorials/infrastructure-management/terraform-quickstart).
3. Установленный [Yandex Cloud CLI](https://cloud.yandex.ru/docs/cli/quickstart).
4. Полученный [OAuth-токен](https://yandex.cloud/ru/docs/iam/concepts/authorization/oauth-token).
5. Конфигурация учетных данных Yandex Cloud с помощью команды:
   ```bash
   yc init
   ```

## Как использовать
1. Склонировать данный репозиторий:
   ```bash
   git clone https://github.com/spbNeroGen/iac-terraform.git
   ```
2. Перейти в нужный проект:
   ```bash
   cd iac-terraform/project-N
   ```
3. Инициализировать Terraform:
   ```bash
   terraform init
   ```
4. Проверить план конфигруации:
   ```bash
   terraform plan
   ```
5. Применить конфигурации:
   ```bash
   terraform apply
   ```
   Подтвердить выполнение операции вводом `yes`.

## Переменные
Некоторые проекты могут требовать указания переменных. 
- Чувствительные переменные могут быть заданы в файле `creds.auto.tfvars` или через командную строку:
    ```bash
    terraform apply -var 'variable_name=value'
    ```

## Полезные команды

- Получить список публичных образов 
    ```bash
    yc compute image list --folder-id standard-images
    ```

- Получить image_id для семейства 'ubuntu-2204-lts'
    ```bash
    yc compute image list --folder-id standard-images | grep 'ubuntu-2204-lts'
    ```

- Список виртуальных машин (экземпляров)
    ```bash
    yc compute instance list
    ```

- Список сетей
    ```bash
    yc vpc network list
    ```

- Список подсетей
    ```bash
    yc vpc subnet list
    ```

- Доступные зоны
    ```bash
    yc compute zone list
    ```

- Cloud id 
    ```bash
    yc config get cloud-id
    ```

- Folder id 
    ```bash
    yc config get folder-id
    ```
