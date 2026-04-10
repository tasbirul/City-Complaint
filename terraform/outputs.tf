output "master_public_ip" {
  description = "Public IP of the Master node"
  value       = aws_instance.master.public_ip
}

output "master_private_ip" {
  description = "Private IP of the Master node (used by kubeadm advertise address)"
  value       = aws_instance.master.private_ip
}

output "worker_public_ips" {
  description = "Public IPs of the Worker nodes"
  value       = aws_instance.worker[*].public_ip
}

output "ssh_master_command" {
  description = "Command to SSH into the master node"
  value       = "ssh -i ~/Documents/${var.key_name}.pem ubuntu@${aws_instance.master.public_ip}"
}

output "ansible_inventory_check_command" {
  description = "Command to verify the Ansible dynamic inventory discovers all nodes"
  value       = "cd ansible && ansible-inventory -i inventory/aws_ec2.yml --list"
}

# ------------------------------------------------------------------------------
# ECR Repository URLs — use these in the CI pipeline and K8s manifests
# ------------------------------------------------------------------------------

output "ecr_complaint_service_url" {
  description = "ECR URL for city-complaint/complaint-service"
  value       = aws_ecr_repository.services["city-complaint/complaint-service"].repository_url
}

output "ecr_admin_service_url" {
  description = "ECR URL for city-complaint/admin-service"
  value       = aws_ecr_repository.services["city-complaint/admin-service"].repository_url
}

output "ecr_progress_service_url" {
  description = "ECR URL for city-complaint/progress-service"
  value       = aws_ecr_repository.services["city-complaint/progress-service"].repository_url
}

output "ecr_frontend_url" {
  description = "ECR URL for city-complaint/frontend"
  value       = aws_ecr_repository.services["city-complaint/frontend"].repository_url
}

output "ecr_registry" {
  description = "Base ECR registry URL (used for docker login)"
  value       = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com"
}