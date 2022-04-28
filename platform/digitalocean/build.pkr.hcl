packer {
  required_plugins {
    digitalocean = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/digitalocean"
    }
  }
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

locals {
  image_name = "lume-web-dns-relay-${local.timestamp}"
}

variable "do_token" {
  type      = string
  default   = "${env("DIGITALOCEAN_TOKEN")}"
  sensitive = true
}

source "digitalocean" "ubuntu" {
  api_token     = "${var.do_token}"
  image         = "ubuntu-18-04-x64"
  region        = "nyc3"
  size          = "s-1vcpu-1gb"
  snapshot_name = "${local.image_name}"
  ssh_username  = "root"
}

build {
  name = "digitalocean"

  sources = ["source.digitalocean.ubuntu"]

  provisioner "shell" {
    inline = ["cloud-init status --wait"]
  }

  provisioner "shell" {
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive", "LC_ALL=C", "LANG=en_US.UTF-8", "LC_CTYPE=en_US.UTF-8"
    ]
    inline           = [
      "apt -qqy update",
      "apt -qqy -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' full-upgrade",
      "apt-get -qqy clean"
    ]
  }

  provisioner "file" {
    source      = "../../provision.sh"
    destination = "/var/lib/cloud/scripts/per-instance/provision.sh"
  }
  provisioner "shell" {
    inline = ["chmod +x /var/lib/cloud/scripts/per-instance/provision.sh"]
  }

  provisioner "shell" {
    script = "../../build.sh"
  }
  provisioner "shell" {
    script = "post-setup.sh"
  }
}
