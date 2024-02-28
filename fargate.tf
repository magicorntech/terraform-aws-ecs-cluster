# Create ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "${var.tenant}-${var.name}-fargate-${var.environment}"

  tags = {
    Name        = "${var.tenant}-${var.name}-fargate-${var.environment}"
    Tenant      = var.tenant
    Module      = var.name
    Environment = var.environment
    Terraform   = "yes"
  }
}

resource "aws_ecs_cluster_capacity_providers" "ondemand" {
  count              = (var.spot_cluster == false) ? 1 : 0
  cluster_name       = aws_ecs_cluster.main.name
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base              = 0
    weight            = 0
    capacity_provider = "FARGATE_SPOT"
  }

  default_capacity_provider_strategy {
    base              = 0
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

resource "aws_ecs_cluster_capacity_providers" "spot" {
  count              = (var.spot_cluster == true) ? 1 : 0
  cluster_name       = aws_ecs_cluster.main.name
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base              = 0
    weight            = 100
    capacity_provider = "FARGATE_SPOT"
  }

  default_capacity_provider_strategy {
    base              = 0
    weight            = 0
    capacity_provider = "FARGATE"
  }
}