terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.34.0"

    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "ec2" {
  ami           = "ami-002070d43b0a4f171"
  instance_type = "t2.micro"

  user_data = <<-EOF
        #!/bin/bash
        mkdir -p /test/test1
        cd /test/test1/
        EOF

  tags = {
    Name = "terraform-example"
  }
}
