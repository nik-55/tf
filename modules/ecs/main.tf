resource "aws_ecr_repository" "remote_dev_ecr" {
  name                 = "remote-dev-ecr"
  image_tag_mutability = "MUTABLE"

  tags = {
    Name = "dev"
  }
}

resource "aws_ecr_repository" "remote_dev_ecr_apache" {
  name                 = "remote-dev-ecr-apache"
  image_tag_mutability = "MUTABLE"

  tags = {
    Name = "dev"
  }
}

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

  network_mode       = "awsvpc"
  execution_role_arn = var.ecs_ecr_role

  container_definitions = jsonencode([{
    name      = "remote-dev-container"
    image     = "${aws_ecr_repository.remote_dev_ecr.repository_url}:latest"
    memory    = 1024
    cpu       = 512
    essential = true
    portMappings = [{
      containerPort = 80
      hostPort      = 80
    }]
    healthCheck = {
      command = ["CMD-SHELL", "curl -f http://localhost:80/ || exit 1"]
    }
  }])

  skip_destroy = true

  depends_on = [aws_ecr_repository.remote_dev_ecr]

  tags = {
    Name = "dev"
  }
}

resource "aws_ecs_task_definition" "remote_dev_task_definition_apache" {
  family = "remote-dev-task-apache"
  memory = 2048
  cpu    = 1024
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  requires_compatibilities = ["FARGATE"]

  execution_role_arn = var.ecs_ecr_role

  network_mode = "awsvpc"

  container_definitions = jsonencode([{
    name      = "remote-dev-container"
    image     = "${aws_ecr_repository.remote_dev_ecr_apache.repository_url}:latest"
    memory    = 1024
    cpu       = 512
    essential = true
    portMappings = [{
      containerPort = 80
      hostPort      = 80
    }]
    healthCheck = {
      command = ["CMD-SHELL", "curl -f http://localhost:80/ || exit 1"]
      timeout = 10
    }
  }])

  skip_destroy = true

  depends_on = [aws_ecr_repository.remote_dev_ecr_apache]

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

  depends_on = [aws_ecs_task_definition.remote_dev_task_definition]

  tags = {
    Name = "dev"
  }
}


resource "aws_ecs_service" "remote_dev_service_apache" {
  name             = "remote-dev-service-apache"
  cluster          = aws_ecs_cluster.remote_dev_cluster.id
  task_definition  = aws_ecs_task_definition.remote_dev_task_definition_apache.arn
  desired_count    = 3
  launch_type      = "FARGATE"
  platform_version = "LATEST"

  network_configuration {
    subnets          = var.subnets
    security_groups  = var.security_groups
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn_apache
    container_name   = "remote-dev-container"
    container_port   = 80
  }

  depends_on = [aws_ecs_task_definition.remote_dev_task_definition_apache]

  tags = {
    Name = "dev"
  }
}
