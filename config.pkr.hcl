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
  script_id     = "404fa2d6-ba19-4963-83ee-6485f85afa00"
}

build {
  sources = ["source.vultr.ubuntu"]
  provisioner "shell" {
    script = "build.sh"
  }
  provisioner "file" {
    source      = "provision.sh"
    destination = "/var/lib/cloud/scripts/per-instance/provision.sh"
  }
  provisioner "shell" {
    inline = ["chmod +x /var/lib/cloud/scripts/per-instance/provision.sh"]
  }
}
