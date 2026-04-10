variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for tagging all resources"
  type        = string
  default     = "city-complaint"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "ami_id" {
  description = "Ubuntu 22.04 AMI ID (us-east-1)"
  type        = string
  default     = "ami-0ec10929233384c7f"
}

variable "master_instance_type" {
  description = "EC2 instance type for the Kubernetes master node — needs ≥2 GB RAM (kubeadm min: 1700 MB)"
  type        = string
  default     = "t3.small"
}

variable "worker_instance_type" {
  description = "EC2 instance type for Kubernetes worker nodes"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
  default     = "aws-vm-ssh-key"
}