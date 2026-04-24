variable "rds_enabled" {
  description = "Flag to enable/disable RDS creation"
  type        = bool
  default     = true

}

variable "tfc_rds_object" {
  description = "RDS Object for RDS creation"
  type = map(object({
    db_instance_identifier = string
    allocated_storage      = number
    engine                 = string
    engine_version         = string
    instance_class         = string
    username               = string
    password               = string
    db_name                = string
    vpc_key                = string

    sg_key = string
    allowed_sg_key = string
    # subnet-group           = string
  }))
  default = {}

}

variable "private_subnet_ids" {
  description = "Map of private subnet IDs grouped by key for RDS creation"
  type        = map(list(string))
  default     = {}

}

variable "security_group_id" {
  description = "Security Group ID map for RDS creation"
  type        = map(string)
  default     = {}

}