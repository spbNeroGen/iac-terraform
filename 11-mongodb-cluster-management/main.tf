module "create_vpc" {
  source       = "./create_vpc"
  network_name = "mongodb-network"

  subnets = {
    "zone-a" : {
      zone           = "ru-central1-a"
      v4_cidr_blocks = ["10.1.0.0/16"]
    },
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

module "managed_mongodb" {
  source            = "./create_mongodb"
  network_id        = module.create_vpc.vpc_network_id
  security_group_ids = [module.create_vpc.security_group_id]
  cluster_name      = "mongodb-cluster"
  environment       = "PRODUCTION"
  cluster_version   = "6.0"

  hosts = [
    {
      zone_id   = "ru-central1-a"
      subnet_id = module.create_vpc.subnet_ids_by_zones["ru-central1-a"]
      type      = "mongod"
    },
    {
      zone_id   = "ru-central1-b"
      subnet_id = module.create_vpc.subnet_ids_by_zones["ru-central1-b"]
      type      = "mongoinfra"
    },
    {
      zone_id   = "ru-central1-d"
      subnet_id = module.create_vpc.subnet_ids_by_zones["ru-central1-d"]
      type      = "mongoinfra"
    },
    {
      zone_id   = "ru-central1-d"
      subnet_id = module.create_vpc.subnet_ids_by_zones["ru-central1-d"]
      type      = "mongoinfra"
    }
  ]

  users = [
    {
      name     = "user1"
      password = "user1user1"
    }
  ]

  databases = [
    {
      name = "db1"
    }
  ]
  depends_on = [module.create_vpc]
}
