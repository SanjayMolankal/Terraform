terraform {
  backend "s3" {
    region  = "us-west-2"
    bucket  = "San-S3-Bucket"
    key     = "terraform.tfstate"
    dynamodb_table = "terraform-lock-table"  # optional for state locking
  }
}

 metadata_options {
    http_tokens   = "required"  # Forces IMDSv2
    http_endpoint = "enabled"   # Keep metadata endpoint enabled
  }

resource "aws_instance" "my_server" {
  ami           = "ami-0a55ba1c20b74fc30"
  instance_type = "t2.micro"
  
  tags = {
    Name = "My_New_Server"
  }
}
