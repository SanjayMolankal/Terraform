output "instance_ip_addr" {
  value = aws_instance.instance.public_ip
}

output "instance_ip_private_addr" {
  value = aws_instance.instance.private_ip
}

output "vpc_id" {
  value = aws_vpc.Dev-vpc.id
}

output "security_group_id" {
  value = aws_security_group.ssh-allowed-sg.id
}
