output "lb_dns_name" {
  value = aws_lb.remote_dev_lb.dns_name
}

output "target_group_arn" {
  value = var.target_type == "instance" ? aws_lb_target_group.remote_dev_tg[0].arn : aws_lb_target_group.remote_dev_tg_ip[0].arn
}

output "target_group_arn_apache" {
  value = var.target_type == "instance" ? aws_lb_target_group.remote_dev_tg[0].arn : aws_lb_target_group.remote_dev_tg_ip_apache[0].arn
}