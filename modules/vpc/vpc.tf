resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr
    tags = {
        "Name" = "${var.project_name}_vpc"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id      = aws_vpc.vpc.id
    tags        = {
        "Name"  = "${var.project_name}_igw"
    }
}

resource "aws_subnet" "public_sub" {
    count                   = length(var.public_subnet_cidr)
    vpc_id                  = aws_vpc.vpc.id
    availability_zone       = data.aws_availability_zones.available.names[count.index]
    map_public_ip_on_launch = true
    cidr_block              = var.public_subnet_cidr[count.index]
    tags = {
        "Name" = "${var.project_name}_public_sub_az${count.index}"
    }
}

resource "aws_eip" "eip" {
    count = length(var.public_subnet_cidr)
    vpc   = true
}

resource "aws_route_table" "rt_publicsub" {
    count           = length(var.public_subnet_cidr)
    vpc_id          = aws_vpc.vpc.id
    route {
        cidr_block  = "0.0.0.0/0"
        gateway_id  = aws_internet_gateway.igw.id
    }
    tags = {
        "Name" = "${var.project_name}_rt_publicsub${count.index}"
    }
}

resource "aws_route_table_association" "associate_route_public_sub" {
    count             = length(var.public_subnet_cidr)
    subnet_id         = aws_subnet.public_sub.*.id[count.index]
    route_table_id    = aws_route_table.rt_publicsub.*.id[count.index]
}
