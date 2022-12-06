resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "ec2_vpc"
  }
}


resource "aws_subnet" "my_public_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-southeast-1a"

  tags = {
    Name = "dev-public"
  }
}

resource "aws_internet_gateway" "my_internet_gateway" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "dev-igw"
  }
}

resource "aws_route_table" "my_public_rt" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "dev_public_rt"
  }
}


resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.my_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_internet_gateway.id
}


resource "aws_route_table_association" "my_public_assoc" {
  subnet_id      = aws_subnet.my_public_subnet.id
  route_table_id = aws_route_table.my_public_rt.id
}


resource "aws_security_group" "my_sg" {
  name        = "dev_sg"
  description = "dev security group"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    # This should set to your public IP
    cidr_blocks = ["112.134.21.88/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}




/*
resource "aws_key_pair" "my_auth" {
  key_name   = "my_key"
  public_key = file("/home/ec2-user/.ssh/id_ed25519.pub")
}
*/

resource "aws_instance" "ec2_dev" {
  instance_type          = "t2.micro"
  ami                    = "ami-0f62d9254ca98e1aa"
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  subnet_id              = aws_subnet.my_public_subnet.id
  #key_name               = aws_key_pair.my_auth.id
  # key-pair was created manually in aws console and configured here
  # reference https://jhooq.com/terraform-ssh-into-aws-ec2/
  key_name               = "ap-southeast-1-key"

  root_block_device {
    volume_size = 20
  }
  tags = {
    Name = "dev-node"
  }
}
