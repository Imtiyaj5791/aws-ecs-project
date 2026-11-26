output "vpc_id" {
  description = "ID of the shared VPC"
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "CIDR block of the shared VPC"
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "Public subnet IDs grouped by environment"
  value = {
    for env, subnet in aws_subnet.public :
    env => subnet.id
  }
}

output "private_subnet_ids" {
  description = "Private subnet IDs grouped by environment"
  value = {
    for env, subnet in aws_subnet.private :
    env => subnet.id
  }
}

output "public_subnet_2_ids" {
  description = "Public subnet IDs in second AZ"
  value = {
    for env, subnet in aws_subnet.public_2 :
    env => subnet.id
  }
}

output "private_subnet_2_ids" {
  description = "Private subnet IDs in second AZ"
  value = {
    for env, subnet in aws_subnet.private_2 :
    env => subnet.id
  }
}