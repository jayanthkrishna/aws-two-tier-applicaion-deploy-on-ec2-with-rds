
resource "aws_vpc" "myvpc" {
  cidr_block = var.vpc_cidr
  tags = {
    "Name"= "${var.project-name}-vpc"
  }
}

resource "aws_subnet" "public_subnet1" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.public_subnet1
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    "Name"= "${var.project-name}-public-subnet1"
  }
}


resource "aws_subnet" "public_subnet2" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.public_subnet2
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

   tags = {
    "Name"= "${var.project-name}-public-subnet2"
  }
}



resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc.id

   tags = {
    "Name"= "${var.project-name}-igw"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myigw.id

  }

   tags = {
    "Name"= "${var.project-name}-route-table"
  }
}

resource "aws_route_table_association" "publicrtb1" {
  route_table_id = aws_route_table.route_table.id
  subnet_id = aws_subnet.public_subnet1.id
}

resource "aws_route_table_association" "publicrtb2" {
  route_table_id = aws_route_table.route_table.id
  subnet_id = aws_subnet.public_subnet2.id
}

####### Private subnets and Nat gateways

resource "aws_subnet" "private_subnet1" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.private_subnet1
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false

   tags = {
    "Name"= "${var.project-name}-private-subnet1"
  }
}


resource "aws_subnet" "private_subnet2" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.private_subnet2
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    "Name"= "${var.project-name}-private-subnet2"
  }
}

resource "aws_eip" "eip-1" {
  domain = "vpc"

   tags = {
    "Name"= "${var.project-name}-nat-gw-1-eip"
  }
}

resource "aws_nat_gateway" "nat-gw-1" {
    subnet_id = aws_subnet.public_subnet1.id
    allocation_id = aws_eip.eip-1.id

    tags = {
    "Name"= "${var.project-name}-nat-gw-1"
  }
    
}

resource "aws_eip" "eip-2" {
  domain = "vpc"

   tags = {
    "Name"= "${var.project-name}-nat-gw-2-eip"
  }
}

resource "aws_nat_gateway" "nat-gw-2" {
    subnet_id = aws_subnet.public_subnet2.id
    allocation_id = aws_eip.eip-2.id

    tags = {
    "Name"= "${var.project-name}-nat-gw-2"
  }
    
}

resource "aws_route_table" "private_subnet1-rt" {
    vpc_id = aws_vpc.myvpc.id
    
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat-gw-1.id
    }

    tags = {
    "Name"= "${var.project-name}-private-subnet1-rt"
    }
    
  
}

resource "aws_route_table_association" "privatertb1" {
  route_table_id = aws_route_table.private_subnet1-rt.id
  subnet_id = aws_subnet.private_subnet1.id
}

resource "aws_route_table" "private_subnet2-rt" {
    vpc_id = aws_vpc.myvpc.id
    
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat-gw-2.id
    }

    tags = {
    "Name"= "${var.project-name}-private-subnet2-rt"
    }
    
  
}

resource "aws_route_table_association" "privatertb2" {
  route_table_id = aws_route_table.private_subnet2-rt.id
  subnet_id = aws_subnet.private_subnet2.id
}