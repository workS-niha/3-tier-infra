
module "mabbu-vpc" {
  source      = "./modules/vpc"
  env         = var.common_vars["env"]
  app_name    = var.common_vars["app_name"]
  common_tags = var.common_vars["common_tags"]
  vpc_cidr    = var.vpc["vpc_cidr"]
  pub_cidr    = var.vpc["pub_cidr"]
  pvt_cidr    = var.vpc["pvt_cidr"]
  db_cidr     = var.vpc["db_cidr"]
  az          = var.vpc["az"]

}

