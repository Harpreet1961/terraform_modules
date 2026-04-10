provider "aws" {
  region = "ap-south-1"

}

module "vpc_object" {
  source             = "./modules/VPC"
  tfc_vpc_object     = var.tfc_vpc_object
  tfc_subnets_object = var.tfc_subnets_object


}

module "sg_object" {
    source        = "./modules/security_group"
    tfc_sg_object = var.tfc_sg_object
    sg_enabled    = var.sg_enabled
    vpc_id        = module.vpc_object.vpc_id

  depends_on = [ module.vpc_object ]
}

module "ec2_object" {
    source             = "./modules/ec2baseline"
    tfc_ec2_object     = var.tfc_ec2_object
    ec2_enabled        = var.ec2_enabled
    subnet_id          = module.vpc_object.subnet_id
    security_group_id   = module.sg_object.sg_id

  depends_on = [ module.vpc_object, module.sg_object ]
  
}