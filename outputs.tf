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