

resource "aws_security_group" "sg" {
  for_each    = { for k, v in var.tfc_sg_object : k => v if var.sg_enabled }
  name        = each.value.sg_name
  description = each.value.description
  vpc_id      = var.vpc_id[each.value.vpc_key]
  dynamic "ingress" {
    for_each = each.value.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }

  }
  dynamic "egress" {
    for_each = each.value.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = each.value.sg_name
  }

}