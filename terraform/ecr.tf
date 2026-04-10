# ==============================================================================
# ECR Repositories for City-Complaint Microservices
# ==============================================================================
# One private registry per deployable image. Each repo has:
#   - MUTABLE tags  : allows overwriting :dev and :latest tags on each push
#   - Scan on push  : free AWS-native CVE scanning for every image pushed
#   - Lifecycle rule: keep only the last 10 images to avoid unbounded AWS costs
# ==============================================================================

# Used to dynamically build the ECR registry base URL in outputs.tf
data "aws_caller_identity" "current" {}

locals {
  ecr_repos = [
    "city-complaint/complaint-service",
    "city-complaint/admin-service",
    "city-complaint/progress-service",
    "city-complaint/frontend",
  ]
}

resource "aws_ecr_repository" "services" {
  for_each = toset(local.ecr_repos)

  name                 = each.value
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Project = var.project_name
  }
}

# ------------------------------------------------------------------------------
# Lifecycle Policy — keep the 10 most recent images, expire older ones
# ------------------------------------------------------------------------------
resource "aws_ecr_lifecycle_policy" "services" {
  for_each   = aws_ecr_repository.services
  repository = each.value.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 10 images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
