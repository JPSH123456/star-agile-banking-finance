//Security group creation and whitelisting the ip
resource "aws_security_group" "allow_tls" {
  name = "terraform-sg"

  ingress {
 description = "HTTPS traffic"
 from_port = 443
 to_port = 443
 protocol = "tcp"
 cidr_blocks = ["0.0.0.0/0"]
 }
ingress {
 description = "HTTP traffic"
 from_port = 0
 to_port = 65000
 protocol = "tcp"
 cidr_blocks = ["0.0.0.0/0"]
 }
 ingress {
 description = "SSH port"
 from_port = 22
 to_port = 22
 protocol = "tcp"
 cidr_blocks = ["0.0.0.0/0"]
 }
 egress {
 from_port = 0
 to_port = 0
 protocol = "-1"
 cidr_blocks = ["0.0.0.0/0"]
 ipv6_cidr_blocks = ["::/0"]
 }
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region     = "ap-northeast-1"
}
resource "aws_instance" "myec2" {
  ami                    = "ami-0b828c1c5ac3f13ee"
  instance_type          = "t2.micro"
  availability_zone = "ap-northeast-1a"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  key_name = "tokyo1"
  tags = {
    Name = "test-server"
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.myec2.public_ip} > /etc/ansible/hosts"
  }
}
resource "aws_key_pair" "deployer" {
  key_name   = "dep_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCgEgx2aQRESTHi0gUR6y863bvFEZ/nYsh6UJylZR3Ed8alOLDJ7ti6VZMo9egnqg/TWm1KYyOg+xSlfY7EldCXI6tN0Tmbd5yRMJOxoK6LkOzfwsWIJUBkKNBs9u5jZ+YkEej11KuAFMbhulkpakouS2Bv7RCDoZT43vpYsqZsNjHaTPr6DggAu8QoiTwMdSE2RzNTi6rPL9jBJ+daCEcXlbD99HE5gW3Wx6feK/jzX5MmzGPTBdZ1i0Q6roDvgtGB0LfBkgMKXJ5hpiO01twGn3sV8sssh2jy6dZcbttVOR/7fbJrtdhuXfnwxSndghPaO6hruTwL4S5KEwMp3AAZ"
}
