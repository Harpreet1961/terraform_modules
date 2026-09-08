output "db_subnet_group_name" {
  value = {
    for k, v in aws_db_subnet_group.rds_subnet_group : k => v.name
  }
  description = "RDS DB Subnet Group names created by the module"
}

output "endpoint" {
  value = {
    for k, v in aws_db_instance.rds : k => v.endpoint
  }
  description = "RDS Endpoint created by the module"

}

output "arn" {
  value = {
    for k, v in aws_db_instance.rds : k => v.arn
  }
  description = "RDS ARN created by the module"

}

output "username" {
  value = {
    for k, v in aws_db_instance.rds : k => v.username
  }
  description = "RDS Username created by the module"

}