output "vpc_id" {
  value = {
    for k, v in local.vpc_obj : k => v.vpc_id
  }
  description = "VPC ID created by the module"

}