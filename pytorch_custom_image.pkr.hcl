packer {
    required_plugins {
      oracle = {
        source = "github.com/hashicorp/oracle"
        version = ">= 1.0.3"
      }
    }
}

variable "compartment_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "shape" {
  type = string
  default = "VM.Standard.E2.1"
}

source "oracle-oci" "pytorch_inference" {
  availability_domain = "mtWI:EU-FRANKFURT-1-AD-3"
  #base_image_ocid     = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaamknfoffmp5wfsshtyxqub53vv7zvyvkdaw36bncume4hnlxcigvq"
  # or use an image filter
  base_image_filter  {
    #display_name = "Oracle-Linux-8.9-2024.01.26-0"
    display_name_search =  "^Oracle-Linux-8.9*"
  }
  compartment_ocid    = "${var.compartment_id}"
  image_name          = "pytorch_inference"
  shape               = "${var.shape}"
  ssh_username        = "opc"
  subnet_ocid         = "${var.subnet_id}"
  skip_create_image = true
}

build {
  sources = [
    "source.oracle-oci.pytorch_inference"
  ]
  provisioner "shell" {
    inline = [
      "sudo dnf install -y ansible"
    ]
  }
  provisioner "ansible-local" {
    playbook_file   = "${path.root}/ansible/system_reqs.yaml"
    extra_arguments = ["-v", "--become"]
  }
  provisioner "ansible-local" {
    playbook_file   = "${path.root}/ansible/pytorch.yaml"
    extra_arguments = ["-v"]
  }
}
