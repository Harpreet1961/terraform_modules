resource "aws_instance" "ec2" {
 for_each = { for k, v in var.tfc_ec2_object : k => v if var.ec2_enabled }
  ami           = each.value.ami_id
  instance_type = each.value.instance_type
  subnet_id     = var.subnet_id[each.value.subnet_key]
  key_name =      aws_key_pair.key_pair[each.value.instance_name].key_name
  vpc_security_group_ids = [var.security_group_id[each.value.sg_key]]
  tags = {
    Name = each.value.instance_name
  }
  
}
resource "aws_key_pair" "key_pair" {
  for_each = { for k, v in var.tfc_ec2_object : k => v if var.ec2_enabled }
  key_name   = "${each.value.instance_name}-key"
  public_key = file("~/.ssh/id_rsa.pub")
  
}