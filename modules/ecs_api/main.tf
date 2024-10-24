# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository
resource "aws_ecr_repository" "main_api" {
  name                 = "${var.container_cluster_name}-${var.container_api_name}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition
resource "aws_ecs_task_definition" "main_api" {
  family                   = "${var.container_cluster_name}-${var.container_api_name}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = var.container_api_exec_role_arn
  container_definitions    = <<TASKDEF
  [
      {
          "name": "${var.container_api_name}",
          "image": "${aws_ecr_repository.main_api.repository_url}:${var.container_api_version}",
          "cpu": 0,
          "portMappings": [
              {
                  "name": "api-8080-tcp",
                  "containerPort": 8080,
                  "hostPort": 8080,
                  "protocol": "tcp",
                  "appProtocol": "http"
              }
          ],
          "essential": true,
          "environment": [
              {
                  "name": "SPRING_DATASOURCE_URL",
                  "value": "jdbc:postgresql://${var.container_api_envvar_value_db_endpoint}:${var.container_api_envvar_value_db_port}/${var.container_api_envvar_value_db_name}${var.container_api_envvar_value_db_option}"
              }
          ],
          "environmentFiles": [],
          "mountPoints": [],
          "volumesFrom": [],
          "secrets": [
              {
                  "name": "SPRING_DATASOURCE_USERNAME",
                  "valueFrom": "${var.container_api_envvar_from_db_username}"
              },
              {
                  "name": "SPRING_DATASOURCE_PASSWORD",
                  "valueFrom": "${var.container_api_envvar_from_db_password}"
              }
          ],
          "ulimits": [],
          "logConfiguration": {
              "logDriver": "awslogs",
              "options": {
                  "awslogs-group": "/ecs/${var.container_cluster_name}-${var.container_api_name}",
                  "mode": "non-blocking",
                  "awslogs-create-group": "true",
                  "max-buffer-size": "25m",
                  "awslogs-region": "${var.region}",
                  "awslogs-stream-prefix": "ecs"
              },
              "secretOptions": []
          },
          "systemControls": []
      }
  ]
TASKDEF

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
resource "aws_lb" "main_api" {
  name               = "${var.container_cluster_name}-${var.container_api_name}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.container_api_lb_security_group_ids
  subnets            = var.container_api_lb_subnet_ids

  enable_deletion_protection = false

  #access_logs {
  #  bucket  = aws_s3_bucket.lb_logs.id
  #  prefix  = "test-lb"
  #  enabled = true
  #}
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
resource "aws_lb_target_group" "main_api" {
  name        = "${var.container_cluster_name}-${var.container_api_name}"
  target_type = "ip"
  protocol    = "HTTP"
  port        = var.container_api_port
  vpc_id      = var.vpc_id

  health_check {
    protocol = "HTTP"
    path     = "/actuator/health"
    port     = var.container_api_health_port
    #healthy_threshold   = 3 # Default: 3
    #unhealthy_threshold = 5 # Default: 3
    #timeout             = 60 # Default: HTTP=5, TCP/TLS/HTTP=10, Lambda=30
    #interval            = 90 # Default: 30
    matcher = 200
  }

  lifecycle {
    create_before_destroy = true
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
resource "aws_lb_listener" "main_api" {
  load_balancer_arn = aws_lb.main_api.arn
  protocol          = "HTTP"
  port              = 80

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main_api.arn
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service
resource "aws_ecs_service" "main_api" {
  # Environment
  cluster          = var.container_cluster_id
  launch_type      = "FARGATE"
  platform_version = "LATEST"

  # Deployment
  task_definition = aws_ecs_task_definition.main_api.arn
  name            = var.container_api_name
  desired_count   = var.container_api_count
  # To prevent a race condition during service deletion,
  # make sure to set depends_on to the related aws_iam_role_policy; otherwise,
  # the policy may be destroyed too soon and the ECS service will then get stuck in the DRAINING state.
  #depends_on      = [aws_iam_role_policy.foo]

  network_configuration {
    subnets = var.container_api_service_subnet_ids
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.main_api.arn
    container_name   = var.container_api_name
    container_port   = var.container_api_port
  }

  #lifecycle {
  #  ignore_changes = [
  #    desired_count,
  #    task_definition,
  #    load_balancer,
  #  ]
  #}
}
