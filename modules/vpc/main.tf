locals {
  name = "${var.env}-${var.app_name}"

}

resource "aws_vpc" "mini" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true


  tags = merge(
    {
      Name = "${local.name}-vpc"
    },
    var.common_tags
  )
}

resource "aws_subnet" "pub_sub" {
  count = length(var.pub_cidr)  
  vpc_id     = aws_vpc.mini.id
  cidr_block = var.pub_cidr[count.index]
  availability_zone = var.az[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name = "${local.name}-pubsubs-${count.index+1}"
    },
    var.common_tags
  )
}



# can i use for-each for public cidr
# can you give example for public cidr for for-each
# i use count function to loop  public cidr but i used count.index in availability zone


resource "aws_subnet" "pvt_sub" {
  count = length(var.pvt_cidr)  
  vpc_id     = aws_vpc.mini.id
  cidr_block = var.pvt_cidr[count.index]
  availability_zone = var.az[count.index]

  tags = merge(
    {
      Name = "${local.name}-pvtsubs-${count.index+1}"
    },
    var.common_tags
  )
}


resource "aws_subnet" "db_sub" {
  count = length(var.db_cidr)  
  vpc_id     = aws_vpc.mini.id
  cidr_block = var.db_cidr[count.index]
  availability_zone = var.az[count.index]

  tags = merge(
    {
      Name = "${local.name}-dbsubs-${count.index+1}"
    },
    var.common_tags
  )
}


resource "aws_db_subnet_group" "subs-db" {
  name       = "${local.name}-dbsub-grp"
  subnet_ids = aws_subnet.db_sub[*].id

  tags = merge(
    {
      Name = "${local.name}-dbsubs"
    },
    var.common_tags
  )
}



resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.mini.id
  
  tags = merge(
    {
      Name = "${local.name}-igw"
    },
    var.common_tags
  )
}


resource "aws_route_table" "pub-rt" {
  vpc_id = aws_vpc.mini.id

  
  tags = merge(
    {
      Name = "${local.name}-public"
    },
    var.common_tags
  )
}

resource "aws_route_table" "pvt-rt" {
  vpc_id = aws_vpc.mini.id

  
  tags = merge(
    {
      Name = "${local.name}-private"
    },
    var.common_tags
  )
}

resource "aws_route_table" "db-rt" {
  vpc_id = aws_vpc.mini.id

  
  tags = merge(
    {
      Name = "${local.name}-db"
    },
    var.common_tags
  )
}


resource "aws_route_table_association" "pub-route" {
  count = length(aws_subnet.pub_sub)
  subnet_id      = aws_subnet.pub_sub[count.index].id
  route_table_id = aws_route_table.pub-rt.id
}


resource "aws_route_table_association" "pvt-route" {
    count = length(aws_subnet.pvt_sub)
  subnet_id      = aws_subnet.pvt_sub[count.index].id
  route_table_id = aws_route_table.pvt-rt.id
}

resource "aws_route_table_association" "db-rt" {

     count = length(aws_subnet.db_sub)
    subnet_id = aws_subnet.db_sub[count.index].id 
    route_table_id = aws_route_table.db-rt.id
  
}


resource "aws_route" "public" {
  route_table_id            = aws_route_table.pub-rt.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}


resource "aws_eip" "eip" {
  domain   = "vpc"
}


resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.pub_sub[0].id

    tags = merge(
    {
      Name = "${local.name}-private"
    },
    var.common_tags
  )

  depends_on = [aws_internet_gateway.gw]
}
