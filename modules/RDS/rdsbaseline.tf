resource "aws_db_subnet_group" "rds_subnet_group" {
  for_each   = { for k, v in var.tfc_rds_object : k => v if var.rds_enabled }
  name       = "${each.value.db_instance_identifier}-subnet-group"
  subnet_ids = var.private_subnet_ids[each.value.vpc_key]

  tags = {
    Name = "${each.value.db_instance_identifier}-subnet-group"
  }
}

resource "aws_db_instance" "rds" {
  for_each               = { for k, v in var.tfc_rds_object : k => v if var.rds_enabled }
  identifier             = each.value.db_instance_identifier
  allocated_storage      = each.value.allocated_storage
  engine                 = each.value.engine
  engine_version         = each.value.engine_version
  instance_class         = each.value.instance_class
  db_name                = each.value.db_name
  username               = each.value.username
  password               = each.value.password
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group[each.key].name
  vpc_security_group_ids = [var.security_group_id[each.value.sg_key]]
  skip_final_snapshot    = true
  tags = {
    Name = each.value.db_instance_identifier
  }

  depends_on = [aws_db_subnet_group.rds_subnet_group]
}
