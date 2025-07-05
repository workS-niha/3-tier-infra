
region = "us-east-1"
common_vars = {
  env      = "dev"
  app_name = "spa"
  common_tags = {

    Terraform = true
    owner     = "bptl"
 }
}
    
vpc = { 

    vpc_cidr = "10.1.0.0/16" 
    pub_cidr = ["10.1.1.0/24" , "10.1.2.0/24"]
    pvt_cidr = ["10.1.3.0/24" , "10.1.4.0/24"]
    db_cidr =  ["10.1.5.0/24",   "10.1.6.0/24" ]
    az = ["us-east-1a", "us-east-1b"]
}

