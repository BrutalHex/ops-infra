resource "aws_vpc" "eks" {
  cidr_block           = var.VPC_CIDRBLOCK
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = merge(local.common_tags, {
    Name = "${var.APP_NAME}_eks_VPC"
  })

}

resource "aws_internet_gateway" "eks" {
  vpc_id = aws_vpc.eks.id
  tags = merge(local.common_tags, {
    Name = "${var.APP_NAME}_eks"
  })
}

resource "aws_route_table" "public_eks" {
  vpc_id = aws_vpc.eks.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks.id
  }
  tags = merge(local.common_tags, {
    Name = "${var.APP_NAME}_public_eks"
  })
}





resource "aws_security_group" "eks" {
  vpc_id = aws_vpc.eks.id
  name   = "${var.APP_NAME}_eks"
  tags = merge(local.common_tags, {
    Name = "${var.APP_NAME}_eks"
  })
  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

