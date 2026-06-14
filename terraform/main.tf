terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# ECR REPOSITORIES USING FOR_EACH
resource "aws_ecr_repository" "repositories" {
  for_each = toset(var.ecr_repositories)

  name = each.value
   force_delete = true
}

# SSH KEY PAIR
resource "aws_key_pair" "deployer_key" {
  key_name   = "terraform-ec2-key"
  public_key = file("../terraform-ec2-key.pub")
}

# SECURITY GROUP
resource "aws_security_group" "ec2_sg" {
  name = "ec2-security-group"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] #allows outbound traffic from anywhere
  }
}

# LATEST UBUNTU 24.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# EC2 INSTANCE
resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer_key.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  user_data = file("${path.module}/user_data.sh")

  associate_public_ip_address = true

  tags = {
    Name = "reshma-terraform-ec2"
  }
}