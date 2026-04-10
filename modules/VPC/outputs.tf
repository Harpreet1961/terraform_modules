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
