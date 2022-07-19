terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
  
   backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "<DELETED>"
    region     = "ru-central1-a"
    key        = "issue1/lemp.tfstate"
    access_key = "<DELETED>"
    secret_key = "<DELETED>"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
  
}

provider "yandex" {
  token = "<DELETED>"
  cloud_id                 = "<DELETED>"
  folder_id                = var.folder_id
}

data "yandex_compute_image" "my_image" {
  family = var.instance_family_image
}

resource "yandex_compute_instance" "vm" {
  name = "terraform-${var.instance_family_image}"
  zone = var.netw_zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.my_image.id
    }
  }

  network_interface {
    subnet_id = var.vpc_subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("id_rsa.pub")}"
  }
}
