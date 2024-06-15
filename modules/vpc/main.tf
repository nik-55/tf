resource "aws_vpc" "remote_dev_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "dev"
  }
}

resource "aws_subnet" "remote_dev_subnet_public" {
  vpc_id                  = aws_vpc.remote_dev_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1f"

  tags = {
    Name = "dev"
  }
}

resource "aws_subnet" "remote_dev_subnet_private" {
  vpc_id            = aws_vpc.remote_dev_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1e"

  tags = {
    Name = "dev"
  }
}


resource "aws_internet_gateway" "remote_dev_igw" {
  vpc_id = aws_vpc.remote_dev_vpc.id

  tags = {
    Name = "dev"
  }
}

resource "aws_route_table" "remote_dev_route_table_public" {
  vpc_id = aws_vpc.remote_dev_vpc.id
  tags = {
    Name = "dev"
  }
}

resource "aws_route" "remote_dev_route_public" {
  route_table_id         = aws_route_table.remote_dev_route_table_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.remote_dev_igw.id
}

resource "aws_route_table_association" "remote_dev_route_table_association_public" {
  subnet_id      = aws_subnet.remote_dev_subnet_public.id
  route_table_id = aws_route_table.remote_dev_route_table_public.id
}

resource "aws_security_group" "remote_dev_sg" {
  name   = "remote_dev_sg"
  vpc_id = aws_vpc.remote_dev_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dev"
  }
}

# resource "aws_key_pair" "remote_dev_key_pair" {
#   key_name   = "remote_dev_key_pair"
#   public_key = var.public_key

#   tags = {
#     Name = "dev"
#   }
# }

resource "aws_eip" "remote_dev_eip" {
  domain = "vpc"

  tags = {
    Name = "dev"
  }
}

resource "aws_nat_gateway" "remote_dev_nat" {
  subnet_id         = aws_subnet.remote_dev_subnet_public.id
  connectivity_type = "public"
  allocation_id     = aws_eip.remote_dev_eip.id

  tags = {
    Name = "dev"
  }
}

resource "aws_route_table" "remote_dev_route_table_private" {
  vpc_id = aws_vpc.remote_dev_vpc.id
  tags = {
    Name = "dev"
  }
}

resource "aws_route" "remote_dev_route_private" {
  route_table_id         = aws_route_table.remote_dev_route_table_private.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.remote_dev_nat.id
}

resource "aws_route_table_association" "remote_dev_route_table_association_private" {
  subnet_id      = aws_subnet.remote_dev_subnet_private.id
  route_table_id = aws_route_table.remote_dev_route_table_private.id
}
