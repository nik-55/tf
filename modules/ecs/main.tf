resource "aws_ecs_cluster" "remote_dev_cluster" {
  name = "remote-dev-cluster"

  tags = {
    Name = "dev"
  }
}

resource "aws_ecs_cluster_capacity_providers" "example" {
  cluster_name = aws_ecs_cluster.remote_dev_cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
  }
}

resource "aws_ecs_task_definition" "remote_dev_task_definition" {
  family = "remote-dev-task"
  memory = 2048
  cpu    = 1024
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  requires_compatibilities = ["FARGATE"]

  network_mode = "awsvpc"

  container_definitions = jsonencode([{
    name      = "remote-dev-container"
    image     = "nginx:latest"
    memory    = 1024
    cpu       = 512
    essential = true
    portMappings = [{
      containerPort = 80
      hostPort      = 80
    }]
  }])

  skip_destroy = true

  tags = {
    Name = "dev"
  }
}

resource "aws_ecs_service" "remote_dev_service" {
  name             = "remote-dev-service"
  cluster          = aws_ecs_cluster.remote_dev_cluster.id
  task_definition  = aws_ecs_task_definition.remote_dev_task_definition.arn
  desired_count    = 3
  launch_type      = "FARGATE"
  platform_version = "LATEST"

  network_configuration {
    subnets          = var.subnets
    security_groups  = var.security_groups
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "remote-dev-container"
    container_port   = 80
  }

  tags = {
    Name = "dev"
  }
}
