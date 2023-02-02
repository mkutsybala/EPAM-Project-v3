region = "eu-central-1"

instance_type = "t2.micro"

enable_dns_support = true

vpc_cidr_block = "172.17.0.0/16"

mk_web_srv_pub_net_cidr_block = "172.17.1.0/24"

mk_web_srv_private_ips = ["172.17.1.10"]

tags = {
    name = "EPAM_Project"
    owner = "MK"
    terraform = "true"
}

ami_name = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20220912"