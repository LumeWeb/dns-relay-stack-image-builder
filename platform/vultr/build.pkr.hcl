packer {
  required_plugins {
    vultr = {
      version = ">= 2.4.4"
      source  = "github.com/vultr/vultr"
    }
  }
}

variable "vultr_api_key" {
  type    = string
  default = "${env("VULTR_API_KEY")}"
}

source "vultr" "ubuntu" {
  api_key       = "${var.vultr_api_key}"
  os_id         = "270"
  plan_id       = "vc2-1c-1gb"
  region_id     = "atl"
  state_timeout = "10m"
  ssh_username  = "root"
  snapshot_description = "lume-web-dns-relay"
}

build {
  name = "vultr"

  sources = ["source.vultr.ubuntu"]

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
