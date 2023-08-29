# Declearing Providers
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.7.0"
    }
  }
}

provider "aws" {
  #Configuration options
  region = "us-east-1"
  #profile = "mssanjay0202"
}


#creating resources
locals {
  project_name = "Terraform"
}

resource "aws_instance" "my_server" {
  ami                         = var.ami
  count                       = 2
  instance_type               = "${var.instance_type}"
  key_name                    = "New-key"
  vpc_security_group_ids      = [aws_security_group.sg.id]
  user_data                   = data.template_file.user_data.rendered
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
 depends_on = [
 aws_key_pair.New-key
]
  provisioner "local-exec" { #creating files locally
    command = "echo ${self.private_ip} >> /home/sanjay/Dev-Infra/private_ips.txt"
  }
  provisioner "remote-exec" { #creating files on remote
    inline = [
      "mkdir -p /home/centos/sanjay"
    ]
    connection {
      type        = "ssh"
      user        = "centos"
      host        = self.public_ip
      private_key = file("/home/sanjay/.ssh/id_rsa")

    }
  }
  #copying files from local to remote
 # provisioner "file" {
   # source   = "/home/sanjay/Dev-Infra/"
   # destination = "/home/"

 # connection {
     # type        = "ssh"
     # user        = "centos"
     # host        = self.public_ip
     # private_key = file("/home/sanjay/.ssh/id_rsa")
#}

#}

  tags = { #name of the server or instance
    Name = "New-VM-${local.project_name}-${count.index}"
  }
}

data "template_file" "user_data" {
  template = file("/home/sanjay/Dev-Infra/userdata.yaml")
}

resource "aws_key_pair" "New-key" {
  key_name   = "New-key"
  public_key = var.public_key

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
