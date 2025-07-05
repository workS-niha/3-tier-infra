
output "vpc_id" {
  value = module.mabbu-vpc.mini_id
}

output "public-subs" {
  value = module.mabbu-vpc.pub_sub_id

}

output "subs-publc" {
  value = module.mabbu-vpc.pub_sub_id
}


output "pvt-subs" {
  value = module.mabbu-vpc.pvt_sub_id
}


output "db-subs" {
  value = module.mabbu-vpc.db_sub_id

}

output "grp-db" {
  value = module.mabbu-vpc.db_grp
}
