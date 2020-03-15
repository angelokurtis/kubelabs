terraform {
  required_version = ">= 0.12.23"
}

provider "aws" {
  region = "us-east-2"
  profile = "terraform"
}

resource "aws_instance" "kubernetes" {
  ami = data.aws_ami.razor_crest.id
  instance_type = "t2.micro"
  count = 1
  key_name = "razor-crest"
  security_groups = [
    aws_security_group.kubernetes.name
  ]
  tags = {
    Name = "razor-crest-${count.index + 1}"
  }
}

data "aws_ami" "razor_crest" {
  name_regex = "ami-razor-crest-*"
  most_recent = true
  owners = [
    "self"
  ]
  filter {
    name = "root-device-type"
    values = [
      "ebs"
    ]
  }

  filter {
    name = "virtualization-type"
    values = [
      "hvm"
    ]
  }
}

resource "aws_security_group" "kubernetes" {
  name = "kubernetes"
  description = "Allow SSH inbound traffic"
  ingress {
    cidr_blocks = [
      "179.154.142.30/32"
    ]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}

output "public_dns" {
  value = aws_instance.kubernetes.*.public_dns
}