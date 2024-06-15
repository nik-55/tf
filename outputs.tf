output "dev_ip_1" {
  value       = module.instance_1.public_ip
  description = "Public IP of the first instance"
}

output "dev_ip_2" {
  value       = module.instance_2.public_ip
  description = "Public IP of the second instance"
}

output "dev_ip_3" {
  value       = module.instance_3.public_ip
  description = "Public IP of the third instance"
}

output "lb_dns_name" {
  value       = module.lb.lb_dns_name
  description = "DNS name of the load balancer"
}
