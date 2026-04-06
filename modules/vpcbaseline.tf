locals {
  vpc_obj = {
    for k, v in aws_vpc.vpc : k => {

      cidr_block = v.cidr_block
      vpc_id     = v.id
    }
  }
}

resource "aws_vpc" "vpc" {
  for_each           = { for k, v in var.tfc_vpc_object : k => v if var.vpc_enabled }
  cidr_block         = each.value.cidr_block
  enable_dns_support = each.value.enable_dns_support
  tags = {
    Name = each.value.vpc_name
  }

}

resource "aws_subnet" "public_subnet" {
  for_each                = { for k, v in var.tfc_subnets_object : k => v if v.subnet_type == "public" && var.vpc_enabled }
  vpc_id                  = local.vpc_obj[each.value.vpc_key].vpc_id
  cidr_block              = each.value.cidr_block_subnet
  map_public_ip_on_launch = each.value.map_public_ip_on_launch
  availability_zone       = each.value.availability_zone
  tags = {
    Name = each.value.subnet_name
  }
}
resource "aws_subnet" "private_subnet" {
  for_each                = { for k, v in var.tfc_subnets_object : k => v if v.subnet_type == "private" && var.vpc_enabled }
  vpc_id                  = local.vpc_obj[each.value.vpc_key].vpc_id
  cidr_block              = each.value.cidr_block_subnet_private
  map_public_ip_on_launch = each.value.map_public_ip_on_launch
  availability_zone       = each.value.availability_zone
  tags = {
    Name = each.value.subnet_name
  }

}

resource "aws_internet_gateway" "igw" {
  for_each = { for k, v in var.tfc_vpc_object : k => v if var.igw_enabled && var.vpc_enabled }
  vpc_id   = local.vpc_obj[each.key].vpc_id
  tags = {
    Name = "${each.value.vpc_name}-igw"
  }

}

resource "aws_route_table" "Public_route_table" {
  for_each = { for k, v in var.tfc_subnets_object : k => v if v.subnet_type == "public" && var.vpc_enabled }
  vpc_id   = local.vpc_obj[each.value.vpc_key].vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[each.value.vpc_key].id
  }
  
  tags = {
    Name = "${each.value.subnet_name}-public-rt"
  }

}

resource "aws_route_table_association" "Public_route_table_association" {
  for_each       = { for k, v in var.tfc_subnets_object : k => v if v.subnet_type == "public" && var.vpc_enabled }
  subnet_id      = aws_subnet.public_subnet[each.key].id
  route_table_id = aws_route_table.Public_route_table[each.key].id

}
