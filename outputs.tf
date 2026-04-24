output "vpc_id" {
  value       = module.vpc_object.vpc_id
  description = "VPC ID created by the module"

}

output "sg_id" {
  value       = module.sg_object.sg_id
  description = "Security Group ID created by the module"

}

output "instance_id" {
  value       = module.ec2_object.instane_id
  description = "EC2 Instance ID created by the module"

}

output "subnet_id" {
  value       = module.vpc_object.subnet_id
  description = "Subnet IDs created by the module"

}

output "private_subnet_ids" {
  value       = module.vpc_object.private_subnet_ids
  description = "Private Subnet IDs created by the module"

}

output "public-ip" {
  value       = module.ec2_object.public-ip
  description = "Public IP of EC2 Instance created by the module"

}

output "endpoint" {
  value       = module.rds_object.endpoint
  description = "RDS Endpoint created by the module"

}

output "arn" {
  value       = module.rds_object.arn
  description = "RDS ARN created by the module"
}

output "username" {
  value       = module.rds_object.username
  description = "RDS Username created by the module"

}

output "subnet_name" {
  value       = module.vpc_object.subnet_name
  description = "Subnet Names created by the module"

}
output "private_subnet_name" {
  value       = module.vpc_object.private_subnet_name
  description = "Private Subnet Names created by the module"
}

output "private_subnets_by_vpc" {
  value       = module.vpc_object.private_subnets_by_vpc
  description = "Private subnet IDs grouped by VPC created by the module"

}