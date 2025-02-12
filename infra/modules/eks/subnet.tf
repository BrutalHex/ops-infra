data "aws_availability_zones" "available" {
  state = "available"
}




resource "aws_subnet" "public_subnet" {
  for_each                = var.AZ_NUMBER
  vpc_id                  = aws_vpc.eks.id
  cidr_block              = cidrsubnet(aws_vpc.eks.cidr_block, 4, each.value)
  availability_zone       = data.aws_availability_zones.available.names[each.value - 1]
  map_public_ip_on_launch = true
  tags = merge(local.common_tags, {
    Purpose                                 = "public"
    Name                                    = "${var.APP_NAME}_public_eks"
    "kubernetes.io/role/elb"                = 1
    "kubernetes.io/cluster/${var.APP_NAME}" = "shared"
  })
}


resource "aws_route_table_association" "public-eks" {
  for_each       = aws_subnet.public_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_eks.id
}