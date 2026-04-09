output "vpc_id" {
  value       = module.vpc_object.vpc_id
  description = "VPC ID created by the module"

}

output "sg_id" {
    value       = module.sg_object.sg_id
    description = "Security Group ID created by the module"
  
}