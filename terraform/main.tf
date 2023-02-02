#  PROVIDERS BLOCKS

provider "aws" {
  region  = var.region
  shared_credentials_files = ["/home/ubuntu/.aws/credentials"]
}

provider "http" {
  
}

#DATA BLOCKS

data "aws_ami" "server_ami" {

  owners = ["amazon"]

  filter {
    name   = "name"
    values = [var.ami_name]
  }
}

data "http" "source_public_ip" {
   url = "http://ipv4.icanhazip.com/"
}

# SERVER BLOCKS

resource "aws_instance" "mk_web_srv" {
  ami           = data.aws_ami.server_ami.id
  instance_type = var.instance_type
  #vpc_security_group_ids = [aws_security_group.web_server_access.id]
  key_name = aws_key_pair.mk_web_srv_key.key_name
  network_interface {
    network_interface_id = aws_network_interface.mk_web_srv_pub_net_if.id
	device_index = 0
  }

  tags = {
    name = var.tags.name
    owner = var.tags.owner
    terraform = var.tags.terraform
  }
}

#INFRASTRUCTURE BLOCKS

resource "aws_vpc" "mk_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_support
  tags = {
    name = var.tags.name
    owner = var.tags.owner
    terraform = var.tags.terraform
  }
}

resource "aws_subnet" "mk_web_srv_pub_net" {
  vpc_id            = aws_vpc.mk_vpc.id
  cidr_block        = var.mk_web_srv_pub_net_cidr_block
  map_public_ip_on_launch = true
  tags = {
    name = var.tags.name
    owner = var.tags.owner
    terraform = var.tags.terraform
  }
}

resource "aws_route_table" "mk_rt" {
  vpc_id = aws_vpc.mk_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mk_int_gw.id
  }

  tags = {
    name = var.tags.name
    owner = var.tags.owner
    terraform = var.tags.terraform
  }
}

resource "aws_route_table_association" "mk_rt_association" {
  subnet_id  = aws_subnet.mk_web_srv_pub_net.id
  route_table_id = aws_route_table.mk_rt.id
}

resource "aws_network_interface" "mk_web_srv_pub_net_if" {
  subnet_id   = aws_subnet.mk_web_srv_pub_net.id
  private_ips = var.mk_web_srv_private_ips

  tags = {
    name = var.tags.name
    owner = var.tags.owner
    terraform = var.tags.terraform
  }
}

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = aws_security_group.web_server_access.id
  network_interface_id = aws_instance.mk_web_srv.primary_network_interface_id
}

resource "aws_internet_gateway" "mk_int_gw" {
  vpc_id = aws_vpc.mk_vpc.id

  tags = {
    name = var.tags.name
    owner = var.tags.owner
    terraform = var.tags.terraform
  }
}

resource "aws_security_group" "web_server_access" {
  name        = "web_server_access"
  description = "Allow inbound ssh and http traffic"
  vpc_id      = aws_vpc.mk_vpc.id

 ingress {
    description = "http allow"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
ingress {
    description = "ssh allow"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["${chomp(data.http.source_public_ip.response_body)}/32"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = var.tags.name
    owner = var.tags.owner
    terraform = var.tags.terraform
  }
}

resource "aws_key_pair" "mk_web_srv_key" {
  key_name = "web_srv_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC9/YGZtV+B/Md6ieWA3Of5H800hBSz3jHYk7keYzbzSq2Ilbg0YfcCGI4c83tWdme5iZa6+mF6bSDB5rBh7CyGmT5/ISx71sY/0RKqgGr4HOZxxqufqjrd4IRSfzr1LyHOqSKeoFAI0+lGiF7pJtp3thj9RSW9wvyzByG+UutnrUPfNTRxoB/cWhYZn2ktaf+W/jKETJELT4an9a6RcXRM/1MAp3WLIj85yVwD88bMBSkprH79XzwIIyCNrg5RrwSgfa0q4iTWysCoHZBzhrT7UD0w+A927nFKxLvnSE2CQHQ8gBlP96IEYRYBNgEgaw7jiA7s8nKEcIoqLxqVv4goiA/UB+9oWRNLLpwhJnn0X0UrwzKIprw2u7uB7iAdFGUVH04DfyJown7WYi9oacyopbvi56Y74huGRUu9mst3veQT73QBWE+ZS6+7Wja3cJEIpnKPNyK9FxHpFTXPTyOdDbNyW6Q9H7WDmgn2OmEtWtBAmlgf1DwZd4jQ9x0Y5o0= ubuntu@ip-172-31-23-108"
  tags = {
    name = var.tags.name
    owner = var.tags.owner
    terraform = var.tags.terraform
  }
}