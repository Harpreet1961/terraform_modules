locals {
  vpc_obj= {
    for k, v in aws_vpc.vpc : k => {

    cidr_block = v.cidr_block
    vpc_id = v.id
  }
  }
}

resource "aws_vpc" "vpc" {
    for_each = {for k, v in var.tfc_vpc_object :  k=> v if var.vpc_enabled}
    cidr_block = each.value.cidr_block
    enable_dns_support = each.value.enable_dns_support
    tags = {
      Name = each.value.vpc_name
    }
  
}

resource "aws_subnet" "public_subnet" {
    for_each = {for k, v in var.tfc_subnets_object :  k=> v if v.subnet_type == "public" && var.vpc_enabled}
    vpc_id = "${local.vpc_obj[each.value.vpc_key].vpc_id}"
    cidr_block = each.value.cidr_block_subnet
    map_public_ip_on_launch = each.value.map_public_ip_on_launch
    availability_zone = each.value.availability_zone
    tags = {
      Name = each.value.subnet_name
    }
}
resource "aws_subnet" "private_subnet" {
    for_each = {for k, v in var.tfc_subnets_object :  k=> v if v.subnet_type == "private" && var.vpc_enabled}
    vpc_id = "${local.vpc_obj[each.value.vpc_key].vpc_id}"
    cidr_block = each.value.cidr_block_subnet_private   
    map_public_ip_on_launch = each.value.map_public_ip_on_launch
    availability_zone = each.value.availability_zone
    tags = {
      Name = each.value.subnet_name
    }
  
}
