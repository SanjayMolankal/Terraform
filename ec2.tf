provider "aws" {
 region =  "us-east-1"
}

resource "aws_instance" "ec2" {
 ami = "ami-002070d43b0a4f171"
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

resource "local_file" "test" {
 filename = "test.txt"
 content = <<-EOT
   Specifies the name to attach to the role session. This value is provided to t                                                                                                             he RoleSessionName
   parameter when the AWS CLI calls the AssumeRole operation, and becomes part o                                                                                                             f the assumed
   role user ARN: arn:aws:sts::123456789012:assumed-role/role_name/role_session_                                                                                                             name.
   This is an optional parameter. If you do not provide this value, a session na                                                                                                             me is generated
   automatically. This name appears in AWS CloudTrail logs for entries associate                                                                                                             d with this session.
   Specifies the path to a file that contains an OAuth 2.0 access token or OpenI                                                                                                             D Connect ID token that
   is provided by an identity provider. The AWS CLI loads the contents of this f                                                                                                             ile and passes it as the
   WebIdentityToken argument to the AssumeRoleWithWebIdentity operation.
 EOT
}
