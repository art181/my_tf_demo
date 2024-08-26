output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.my_ubuntu.public_dns
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.my_ubuntu.public_ip
}

output "instance_name" {
  description = "Name (tag) of the EC2 instance"
  value       = aws_instance.my_ubuntu.tags["Name"]
}