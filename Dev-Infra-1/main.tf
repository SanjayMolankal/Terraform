#creating resources
locals {
  project_name = "Terraform"
}

resource "aws_instance" "my_server" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = "New-key"
  vpc_security_group_ids      = [aws_security_group.sg.id]
  user_data                   = data.template_file.user_data.rendered
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> private_ips.txt"
}
  provisioner "remote-exec" {
    inline = [
      "mkdir -p /root/sanjay"
  ]
 connection {
   type   = "ssh"
   user   = "root"
   host   = "${self.public_ip}"
   private_key = "${file("/root/.ssh/id_rsa")}"
 }
}
  tags = { #name of the server or instance
    Name = "New-VM-${local.project_name}"
  }
  depends_on = [module.vpc.vpc_id]
}

data "template_file" "user_data" {
  template = file("userdata.yaml")
}

resource "aws_key_pair" "New-key" {
  key_name   = "New-key"
  public_key = var.public_key

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

