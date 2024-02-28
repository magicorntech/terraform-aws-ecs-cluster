# terraform-aws-ecs-cluster

Magicorn made Terraform Module for AWS Provider
--
```
module "ecs-cluster" {
  source      = "magicorntech/ecs-cluster/aws"
  version     = "0.0.1"
  tenant      = var.tenant
  name        = var.name
  environment = var.environment

  # ECS Cluster Configuration 
  spot_cluster                  = true
  additional_execution_policies = ["CloudWatchLogsFullAccess"]
}
```

## Notes
1) Works with Fargate only.
2) Works better with ALB module.