
output "cluster_name" {
  description = "ECS Cluster name"
  value       = aws_ecs_cluster.this.name
}

output "service_name" {
  description = "ECS Service name"
  value       = aws_ecs_service.this.name
}

output "alb_dns_name" {
  description = "Application Load Balancer DNS name"
  value       = aws_lb.this.dns_name
}
