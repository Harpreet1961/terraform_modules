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
