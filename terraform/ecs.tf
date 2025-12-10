# ECS Cluster
resource "aws_ecs_cluster" "app" {
  name = "chatapp-cluster"
}

# IAM Role für Fargate Tasks
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })
}

resource "aws_cloudwatch_log_group" "chatapp" {
  name              = "/ecs/chatapp"
  retention_in_days = 1
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Security Group für Fargate (Port 3000)
resource "aws_security_group" "ecs_service_sg" {
  name        = "ecs-service-sg"
  description = "Allow HTTP to ECS service"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Task Definition (nutzt dein ECR-Image)
resource "aws_ecs_task_definition" "chatapp" {
  family                   = "chatapp-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name      = "chatapp"
    image     = "942849037433.dkr.ecr.eu-central-1.amazonaws.com/sveltekit-chatapp:latest"
    essential = true

    portMappings = [{
      containerPort = 3000
      hostPort      = 3000
      protocol      = "tcp"
    }]

    # RDS CONNECTION VARS
    environment = [
      # App-Core
      { name = "PORT", value = "3000" },
      { name = "ORIGIN", value = "https://chatapp.marvin-tank.de" },

      # Azure ChatGPT (Microsoft Foundry)
      { name = "AZURE_OPENAI_API_KEY", value = var.azure_openai_api_key },
      { name = "AZURE_OPENAI_API_VERSION", value = var.azure_openai_api_version },
      { name = "AZURE_OPENAI_API_ENDPOINT", value = var.azure_openai_api_endpoint },
      { name = "AZURE_OPENAI_API_MODEL_NAME", value = var.azure_openai_api_model_name },
      { name = "AZURE_OPENAI_API_DEPLOYMENT", value = var.azure_openai_api_deployment },

      # RDS als "Azure MySQL" (Mapping!)
      { name = "AZURE_MYSQL_HOST", value = "chatapp-mysql.cpgwisok2zt1.eu-central-1.rds.amazonaws.com" },
      { name = "AZURE_MYSQL_PORT", value = "3306" },
      { name = "AZURE_MYSQL_USERNAME", value = var.db_username },
      { name = "AZURE_MYSQL_PASSWORD", value = var.db_password },
      { name = "AZURE_MYSQL_DATABASE_NAME", value = var.db_name },

      # Unlock
      { name = "UNLOCK", value = var.unlock_password },

      # Speech (optional)
      { name = "AZURE_SPEECH_KEY", value = var.azure_speech_key },
      { name = "AZURE_SPEECH_REGION", value = var.azure_speech_region }
    ]


    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.chatapp.name
        awslogs-region        = "eu-central-1"
        awslogs-stream-prefix = "chatapp"
      }
    }
  }])
}


# Fargate Service
resource "aws_ecs_service" "chatapp" {
  name            = "chatapp-service"
  cluster         = aws_ecs_cluster.app.id
  task_definition = aws_ecs_task_definition.chatapp.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  # ← DIESER TRICK triggert neuen Deployment!
  # force_new_deployment = true

  # Network: Private Subnets
  network_configuration {
    subnets          = [aws_subnet.private.id, aws_subnet.private_b.id]
    security_groups  = [aws_security_group.ecs_service_sg.id]
    assign_public_ip = false
  }

  # Load Balancer
  load_balancer {
    target_group_arn = aws_lb_target_group.chatapp.arn
    container_name   = "chatapp"
    container_port   = 3000
  }

  depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_role_policy]
}
