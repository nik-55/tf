output "public_ip" {
  value = aws_instance.remote_dev_instance.public_ip
}

output "instance_id" {
  value = aws_instance.remote_dev_instance.id
}