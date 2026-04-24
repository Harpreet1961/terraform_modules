output "instane_id" {
  value = {
    for k, v in aws_instance.ec2 : k => v.id
  }
  description = "EC2 Instance ID created by the module"

}
output "public-ip" {
  value = {
    for k, v in aws_instance.ec2 : k => v.public_ip
  }
  description = "Public IP of EC2 Instance created by the module"

}