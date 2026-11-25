# Private Route Tables - One per Environment
resource "aws_route_table" "private" {
  for_each = var.environment_subnets

  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${each.key}-private-rt"
    Environment = each.key
  }
}

# Associate Private Subnets
resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}