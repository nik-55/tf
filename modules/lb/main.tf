# Target group listening on port 3100
resource "aws_lb_target_group" "remote_dev_tg" {
  name   = "remote-dev-tg"
  vpc_id = var.vpc_details.vpc_id

  port     = 3100
  protocol = "HTTP"

  health_check {
    # Path to health check endpoint
    path     = "/health/"
    protocol = "HTTP"
    port     = 5000
  }

  tags = {
    Name = "dev"
  }

  count = var.target_type == "instance" ? 1 : 0
}

resource "aws_lb_target_group" "remote_dev_tg_ip" {
  name        = "remote-dev-tg"
  vpc_id      = var.vpc_details.vpc_id
  target_type = "ip"

  port     = 3100
  protocol = "HTTP"

  health_check {
    # Path to health check endpoint
    path     = "/"
    protocol = "HTTP"
    port     = 80
  }

  tags = {
    Name = "dev"
  }

  count = var.target_type == "instance" ? 0 : 1
}

# targets are instances listening on port 5000
resource "aws_lb_target_group_attachment" "remote_dev_tg_attachment" {
  target_group_arn = aws_lb_target_group.remote_dev_tg[0].arn

  for_each = var.instances

  port      = each.value.port
  target_id = each.value.id
}

resource "aws_lb" "remote_dev_lb" {
  load_balancer_type = "application"
  name               = "remote-dev-lb"
  internal           = false
  security_groups    = var.vpc_details.security_groups
  subnets            = var.vpc_details.subnets

  tags = {
    Name = "dev"
  }
}

resource "aws_lb_listener" "remote_dev_listener" {
  load_balancer_arn = aws_lb.remote_dev_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = var.target_type == "instance" ? aws_lb_target_group.remote_dev_tg[0].arn : aws_lb_target_group.remote_dev_tg_ip[0].arn
  }
}

resource "aws_lb_target_group" "remote_dev_tg_ip_apache" {
  name        = "remote-dev-tg-apache"
  vpc_id      = var.vpc_details.vpc_id
  target_type = "ip"

  port     = 3100
  protocol = "HTTP"

  health_check {
    # Path to health check endpoint
    path     = "/"
    protocol = "HTTP"
    port     = 80
  }

  tags = {
    Name = "dev"
  }

  count = var.target_type == "instance" ? 0 : 1
}

resource "aws_lb_listener" "remote_dev_listener_apache" {
  load_balancer_arn = aws_lb.remote_dev_lb.arn
  port              = "8000"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = var.target_type == "instance" ? aws_lb_target_group.remote_dev_tg[0].arn : aws_lb_target_group.remote_dev_tg_ip_apache[0].arn
  }
}
