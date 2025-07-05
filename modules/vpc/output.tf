
output "mini_id" {
  value = aws_vpc.mini.id
}

output "pub_sub_id" {
    value = aws_subnet.pub_sub[*].id
  
}

output "pub_sub_ids" {
    value = [for pub in aws_subnet.pub_sub: pub.id ]
  
}


output "pvt_sub_id" {
    value = aws_subnet.pvt_sub[*].id
  
}

output "db_sub_id" {
    value = aws_subnet.db_sub[*].id
  
}

output "db_grp" {
  value = aws_db_subnet_group.subs-db.id
}

