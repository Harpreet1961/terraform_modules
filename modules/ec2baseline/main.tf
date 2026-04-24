resource "aws_instance" "ec2" {
  for_each      = { for k, v in var.tfc_ec2_object : k => v if var.ec2_enabled }
  ami           = each.value.ami_id
  instance_type = each.value.instance_type
  subnet_id     = var.subnet_id[each.value.subnet_key]
  key_name      = aws_key_pair.key_pair[each.key].key_name
  user_data = each.value.environment == "dev" ? templatefile("${path.module}/userdata.sh.tpl",
    {
      environment = each.value.environment
      APP_NAME    = each.value.instance_name
  }) : null

  vpc_security_group_ids = [var.security_group_id[each.value.sg_key]]
  tags = {
    Name = each.value.instance_name
  }

}
resource "aws_key_pair" "key_pair" {
  for_each   = { for k, v in var.tfc_ec2_object : k => v if var.ec2_enabled }
  key_name   = "${each.value.instance_name}-key"
  public_key = file("~/.ssh/id_rsa.pub")

}

resource "aws_ebs_volume" "ebs_volume" {
  for_each          = { for k, v in var.tfc_ec2_object : k => v if var.ec2_enabled && var.ebs_enabled }
  availability_zone = data.aws_subnet.subnet[each.key].availability_zone
  size              = 20
  tags = {
    Name = "${each.value.instance_name}-volume"
  }

}
data "aws_subnet" "subnet" {
  for_each = { for k, v in var.tfc_ec2_object : k => v if var.ec2_enabled }
  id       = var.subnet_id[each.value.subnet_key]
}


resource "aws_volume_attachment" "ebs_attachment" {
  for_each     = { for k, v in var.tfc_ec2_object : k => v if var.ec2_enabled && var.ebs_enabled }
  device_name  = "/dev/sdh"
  volume_id    = aws_ebs_volume.ebs_volume[each.key].id
  instance_id  = aws_instance.ec2[each.key].id
  force_detach = true

}

