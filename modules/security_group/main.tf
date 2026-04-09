

resource "aws_security_group" "sg" {
  for_each = { for k, v in var.tfc_sg_object : k => v if var.sg_enabled }
  name        = each.value.sg_name
  description = each.value.description
  vpc_id      = var.vpc_id[each.value.vpc_key]
    ingress {
     from_port   = each.value.ingress_from_port
     to_port     = each.value.ingress_to_port
     protocol    = each.value.ingress_protocol
     cidr_blocks = each.value.ingress_cidr_blocks
      }
    egress {
     from_port   = each.value.egress_from_port
     to_port     = each.value.egress_to_port
     protocol    = each.value.egress_protocol
     cidr_blocks = each.value.egress_cidr_blocks
      }
  tags = {
    Name = each.value.sg_name
  }
  
}