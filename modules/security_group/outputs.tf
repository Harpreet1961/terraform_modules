output "sg_id" {
  value = {
    for k, v in aws_security_group.sg : k => v.id
  }
  description = "Security Group ID created by the module"

}