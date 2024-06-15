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
}

# targets are instances listening on port 5000
resource "aws_lb_target_group_attachment" "remote_dev_tg_attachment" {
  target_group_arn = aws_lb_target_group.remote_dev_tg.arn

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
    target_group_arn = aws_lb_target_group.remote_dev_tg.arn
  }
}
