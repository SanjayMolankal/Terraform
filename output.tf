output "instance_ip_addr" {
  value = aws_instance.my_server.public_ip
}

output "instance_ip_private_addr" {
  value = aws_instance.my_server.private_ip
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "security_group_id" {
  value = aws_security_group.sg.id
}
