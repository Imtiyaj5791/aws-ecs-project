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

# Second AZ Public Subnets
resource "aws_subnet" "public_2" {
  for_each = var.environment_subnets

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.public_2
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${each.key}-public-subnet-2"
    Environment = each.key
    Type        = "Public"
  }
}

# Second AZ Private Subnets
resource "aws_subnet" "private_2" {
  for_each = var.environment_subnets

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.private_2
  availability_zone = var.availability_zones[1]

  tags = {
    Name        = "${each.key}-private-subnet-2"
    Environment = each.key
    Type        = "Private"
  }
}