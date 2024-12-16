data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  tags = merge(
    {
      Name        = "${var.name}-vpc"
      Environment = var.environment
      Project     = "online-boutique"
      FinOps      = "cost-center:12345"
    },
    var.additional_tags
  )
}

resource "aws_subnet" "public" {
  count                 = length(var.public_subnets)
  vpc_id                = aws_vpc.main.id
  cidr_block            = var.public_subnets[count.index]
  map_public_ip_on_launch = true
  availability_zone     = data.aws_availability_zones.available.names[count.index]
  tags = merge(
    {
      Name        = "${var.name}-public-subnet-${count.index + 1}"
      Environment = var.environment
    },
    var.additional_tags
  )
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = merge(
    {
      Name        = "${var.name}-private-subnet-${count.index + 1}"
      Environment = var.environment
    },
    var.additional_tags
  )
}
resource "aws_security_group" "rds_sg" {
  name        = "${var.name}-rds-sg"
  description = "Security group for RDS instances"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow Postgres access"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Ajuste para um CIDR mais restrito em produção
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name        = "${var.name}-rds-sg"
      Environment = var.environment
    },
    var.additional_tags
  )
}
