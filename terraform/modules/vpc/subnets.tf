# Public Subnets
resource "aws_subnet" "public" {
  for_each = var.environment_subnets

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.public
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${each.key}-public-subnet"
    Environment = each.key
    Type        = "Public"
  }
}

# Private Subnets
resource "aws_subnet" "private" {
  for_each = var.environment_subnets

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.private
  availability_zone = var.availability_zones[0]

  tags = {
    Name        = "${each.key}-private-subnet"
    Environment = each.key
    Type        = "Private"
  }
}