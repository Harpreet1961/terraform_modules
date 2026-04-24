output "vpc_id" {
  value = {
    for k, v in local.vpc_obj : k => v.vpc_id
  }
  description = "VPC ID created by the module"

}

output "public_subnet_ids" {
  value = { for k, v in aws_subnet.public_subnet : k => v.id }
}

output "private_subnet_ids" {
  value = { for k, v in aws_subnet.private_subnet : k => v.id }
}

output "subnet_id" {
  value = merge(
    { for k, v in aws_subnet.public_subnet : k => v.id },
    { for k, v in aws_subnet.private_subnet : k => v.id }
  )
}

output "subnet_name" {
  value = merge(
    { for k, v in aws_subnet.public_subnet : k => v.tags["Name"] },
    { for k, v in aws_subnet.private_subnet : k => v.tags["Name"] }
  )

}

output "private_subnet_name" {
  value = { for k, v in aws_subnet.private_subnet : k => v.tags["Name"] }

}

output "private_subnets_by_vpc" {
  description = "Private subnet IDs grouped by VPC"

  value = {
    for vpc_key in keys(var.tfc_vpc_object) :
    vpc_key => [
      for subnet_key, subnet in aws_subnet.private_subnet :
      subnet.id
      if var.tfc_subnets_object[subnet_key].vpc_key == vpc_key
    ]
  }
}