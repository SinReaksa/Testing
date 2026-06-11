output "instance_public_ip" {
  description = "Public IP of EC2 instance"
  value       = aws_instance.web.public_ip
}

output "instance_id" {
  description = "Instance ID"
  value       = aws_instance.web.id
}