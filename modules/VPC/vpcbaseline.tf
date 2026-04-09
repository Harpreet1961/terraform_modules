locals {
  vpc_obj = {
    for k, v in aws_vpc.vpc : k => {

      cidr_block = v.cidr_block
      vpc_id     = v.id
    }
  }
#  nat_by_az = {
#     for k, v in var.tfc_subnets_object :
#     v.vpc_key => k
#     if v.subnet_type == "public"
#   }

  nat_obj = {
    for k, v in aws_nat_gateway.nat_gw :
    "${var.tfc_subnets_object[k].vpc_key}-${var.tfc_subnets_object[k].availability_zone}" => {
      nat_id = v.id
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
  for_each = { for k, v in var.tfc_subnets_object : k => v if v.subnet_type == "public" && var.vpc_enabled && var.igw_enabled }
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
  for_each       = { for k, v in var.tfc_subnets_object : k => v if v.subnet_type == "public" && var.vpc_enabled && var.igw_enabled }
  subnet_id      = aws_subnet.public_subnet[each.key].id
  route_table_id = aws_route_table.Public_route_table[each.key].id

}

resource "aws_eip" "nat_eip" {
  for_each = { for k, v in var.tfc_subnets_object : k => v if v.subnet_type == "public" && var.vpc_enabled && var.nat_enabled}
  domain = "vpc"
  tags = {
    Name = "${each.value.subnet_name}-nat-eip"
  }
  
}

resource "aws_nat_gateway" "nat_gw" {
  for_each = { for k, v in var.tfc_subnets_object : k => v if v.subnet_type == "public" && var.vpc_enabled && var.nat_enabled}
  allocation_id = aws_eip.nat_eip[each.key].id
  subnet_id     = aws_subnet.public_subnet[each.key].id
  tags = {
    Name = "${each.value.subnet_name}-nat-gw"
  }
  
}

resource "aws_route_table" "Private_route_table" {
  for_each = { for k, v in var.tfc_subnets_object : k => v if v.subnet_type == "private" && var.vpc_enabled && var.nat_enabled }
  vpc_id   = local.vpc_obj[each.value.vpc_key].vpc_id
  route {
    cidr_block     = "0.0.0.0/0"
  # nat_gateway_id = aws_nat_gateway.nat_gw[local.nat_by_az[each.value.vpc_key]].id
    nat_gateway_id = local.nat_obj["${each.value.vpc_key}-${each.value.availability_zone}"].nat_id
  }
    tags = {
        Name = "${each.value.subnet_name}-private-rt"
    }
  
}

resource "aws_route_table_association" "Private_route_table_association" {
    for_each       = { for k, v in var.tfc_subnets_object : k => v if v.subnet_type == "private" && var.vpc_enabled && var.nat_enabled }
    subnet_id      = aws_subnet.private_subnet[each.key].id
    route_table_id = aws_route_table.Private_route_table[each.key].id
  
}
