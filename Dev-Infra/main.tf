#creating VPC

resource "aws_vpc" "Dev-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = "true" #gives you an internal domain name
  enable_dns_hostnames = "true"
  #enable_classiclink   = "false"   #allows classic network-connected Elastic Compute Service (ECS) instances to communicate with cloud resources deployed in VPCs
  instance_tenancy     = "default" #defines how EC2 instances are distributed across physical hardware and affects pricing

  tags = {
    Name = "Dev-vpc"
  }
}

#creating Public subnet
resource "aws_subnet" "Dev-subnet-public-1" {
  vpc_id                 = aws_vpc.Dev-vpc.id
  cidr_block             = "10.0.0.0/24"
  #associate_public_ip_address = true #it makes this a public subnet
  availability_zone      = "us-east-1a"

  tags = {
    Name = "Dev-subnet-public-1"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "Dev-igw" {
  vpc_id = aws_vpc.Dev-vpc.id
  tags = {
    Name = "Dev-igw"
  }
}

#Route Table
resource "aws_route_table" "Dev-public-crt" {
  vpc_id = aws_vpc.Dev-vpc.id

  route {
    //associated subnet can reach everywhere
    cidr_block = "0.0.0.0/0"

    //CRT uses this IGW to reach internet
    gateway_id = aws_internet_gateway.Dev-igw.id
  }

  tags = {
    Name = "Dev-public-crt"
  }
}

#Associating CRT and Subnet
resource "aws_route_table_association" "Dev-crta-public-subnet-1" {
  subnet_id      = "${aws_subnet.Dev-subnet-public-1.id}"
  route_table_id = "${aws_route_table.Dev-public-crt.id}"
}

#Creating Security group
resource "aws_security_group" "ssh-allowed-sg" {
  description = "Allow SSH"
  vpc_id      = aws_vpc.Dev-vpc.id

  ingress {
    description      = "Http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
  }
  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
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
    Name = "allow_SSH"
  }
}

locals {
  project_name = "Terraform"
}

#Creating EC2
resource "aws_instance" "instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = "New-key"
  vpc_security_group_ids = [aws_security_group.ssh-allowed-sg.id]
  subnet_id              = "${aws_subnet.Dev-subnet-public-1.id}"
  associate_public_ip_address = true #it makes this a public subnet

  tags = {
    Name = "New-VM-${local.project_name}"
  }
}

#Public key
resource "aws_key_pair" "New-Key" {
  key_name   = "New-Key"
  public_key = "var.public_key"

  tags = {
    Terraform   = "true"
    Environment = "Dev"
  }
}
