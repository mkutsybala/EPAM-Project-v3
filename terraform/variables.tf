variable "region" {
  type = string
  default = "us-east-1"
  description = "Region for infrastructure deployment"
}

variable "instance_type" {
  type = string
  default = "t2.micro"
  description = "Type of instance (string)"
}

variable "enable_dns_support" {
  type = bool
  default = true
  description = "DNS support (bool)"
}

variable "vpc_cidr_block" {
  type = string
  description = "VPC ip addresses range"
}

variable "mk_web_srv_pub_net_cidr_block" {
  type = string
  description = "Web server publik network ip addresses range"
}

variable "mk_web_srv_private_ips" {
  type = list(string)
  description = "Web server private ip addresses"
}

 variable "ami_name" {
  type = string
  default = "amzn2-ami-kernel-5.10-hvm-2.0.20221004.0-x86_64-gp2"
 }

 variable "tags" {
  type = object({
    name    = string
    owner = string
    terraform = string
  })
 }