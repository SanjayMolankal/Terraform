locals {
  project_name = "Terraform"
}

#creating resources

resource "aws_instance" "my_server" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = "New-key"
  vpc_security_group_ids = [aws_security_group.sg.id]
  user_data              = data.template_file.user_data.rendered
  subnet_id              = module.vpc.public_subnets[0]
  associate_public_ip_address = true

  tags = { #name of the server or instance
    Name = "New-VM-${local.project_name}"
  }
  depends_on = [module.vpc.vpc_id]
}
#Creating vpc with the help of modules
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "New-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true
}

data "template_file" "user_data" {
  template = file("userdata.yaml")
}
resource "aws_security_group" "sg" {
  name        = "SSH"
  description = "Allow SSH"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "Http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["10.0.0.0/16"]
    ipv6_cidr_blocks = []
  }
  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["54.243.15.38/32"]
    ipv6_cidr_blocks = []
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_key_pair" "New-key" {
  key_name   = "New-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDs8sCjFAnwgd5Go39QSsSSaudWVYPmde5pBZgb2KNgo/AfePghFo8PusAV1X8ZdQzzCHTWF49mgy0msnJ+GfmGqgE8PabGrdTkvpIyWx+AXAehDCIsEktNHMvhaiUX3kYfH4MCkF18EfKYC+c/JTKEYGPgLaPurz4kRbIZt1LvjxDC7TzzD/8FK04j+r5JiViu6A2tGqiJ75cmmCkCjAtEH6H3l9cSsuuCLpRjl1fz1f0ZTC2G7YxNKpqqOO7qNgVHjD7pdCeRs8qWMdyDTUvyi3LtnLiWtZgRUjjjSRqZ/ZJsqX24qaRlp1WsyIXr5ZjHDf023A1OMlay6AlUkihj root@ip-172-31-89-2.ec2.internal"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

