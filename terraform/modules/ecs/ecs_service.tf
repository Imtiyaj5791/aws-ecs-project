
resource "aws_ecs_service" "this" {
  name            = "${var.cluster_name}-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  launch_type     = "FARGATE"

  desired_count = 0

  network_configuration {
    subnets          = var.public_subnet_ids
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = var.cluster_name
    container_port   = var.container_port
  }

  depends_on = [
    aws_lb_listener.http
  ]

  lifecycle {
  ignore_changes = [
    desired_count,
    task_definition
  ]
}

  tags = {
    Environment = var.environment
  }
}
