provider "aws" {
  region = var.aws_region
}

# ------------------------------------------------------------------------------
# Networking
# ------------------------------------------------------------------------------

resource "aws_vpc" "k8s_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = { Name = "k8s-vpc" }
}

resource "aws_subnet" "k8s_public_subnet" {
  vpc_id                  = aws_vpc.k8s_vpc.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true

  tags = { Name = "k8s-public-subnet" }
}

resource "aws_internet_gateway" "k8s_igw" {
  vpc_id = aws_vpc.k8s_vpc.id

  tags = { Name = "k8s-igw" }
}

resource "aws_route_table" "k8s_rt" {
  vpc_id = aws_vpc.k8s_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k8s_igw.id
  }

  tags = { Name = "k8s-public-rt" }
}

resource "aws_route_table_association" "k8s_rt_assoc" {
  subnet_id      = aws_subnet.k8s_public_subnet.id
  route_table_id = aws_route_table.k8s_rt.id
}

# ------------------------------------------------------------------------------
# Security Group
# ------------------------------------------------------------------------------

resource "aws_security_group" "k8s_sg" {
  name        = "k8s-cluster-sg"
  description = "Allow required ports for Kubernetes cluster"
  vpc_id      = aws_vpc.k8s_vpc.id

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Kubernetes API Server
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # etcd (internal VPC only)
  ingress {
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  # Kubelet API (internal VPC only)
  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  # NodePort Services
  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Intra-cluster (CNI / pod-to-pod)
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "k8s-sg" }
}

# ------------------------------------------------------------------------------
# EC2 Instances — all in the public subnet (free-tier compatible)
# All nodes get public IPs so Ansible can reach them directly without a bastion.
# ------------------------------------------------------------------------------

resource "aws_instance" "master" {
  ami                  = var.ami_id
  instance_type        = var.master_instance_type
  key_name             = var.key_name
  subnet_id            = aws_subnet.k8s_public_subnet.id
  iam_instance_profile = aws_iam_instance_profile.k8s_node_ecr_profile.name

  vpc_security_group_ids = [aws_security_group.k8s_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y python3
  EOF

  tags = {
    Name    = "k8s-master"
    Role    = "master"
    Project = "kubeadm"
  }
}

resource "aws_instance" "worker" {
  count                = 2
  ami                  = var.ami_id
  instance_type        = var.worker_instance_type
  key_name             = var.key_name
  subnet_id            = aws_subnet.k8s_public_subnet.id
  iam_instance_profile = aws_iam_instance_profile.k8s_node_ecr_profile.name

  vpc_security_group_ids = [aws_security_group.k8s_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y python3
  EOF

  tags = {
    Name    = "k8s-worker-${count.index + 1}"
    Role    = "worker"
    Project = "kubeadm"
  }
}