# Create Task Execution Role
resource "aws_iam_role" "main" {
  name = "${var.tenant}_${var.name}_${data.aws_region.current.name}_execution_role_${var.environment}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name        = "${var.tenant}_${var.name}_${data.aws_region.current.name}_execution_role_${var.environment}"
    Tenant      = var.tenant
    Module      = var.name
    Environment = var.environment
    Terraform   = "yes"
  }
}

# Attach Task Execution Role
resource "aws_iam_role_policy_attachment" "task-exec-attach" {
  role       = aws_iam_role.main.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Loop Additional Task Execution Role Policies
resource "aws_iam_role_policy_attachment" "additional-exec-attach" {
  for_each   = toset(var.additional_execution_policies)
  role       = aws_iam_role.main.name
  policy_arn = "arn:aws:iam::aws:policy/${each.value}"
}