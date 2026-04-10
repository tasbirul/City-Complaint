# ==============================================================================
# IAM Role & Instance Profile — EC2 nodes pull from ECR without credentials
# ==============================================================================
# Strategy:
#   Instead of storing long-lived AWS credentials on the nodes, we attach an
#   IAM Instance Profile. The kubelet uses the instance's identity to obtain
#   short-lived tokens from the STS metadata service, which ECR accepts.
#
# What is attached:
#   AmazonEC2ContainerRegistryReadOnly — grants ecr:GetAuthorizationToken,
#   ecr:BatchGetImage, ecr:GetDownloadUrlForLayer on all repos in the account.
# ==============================================================================

# ------------------------------------------------------------------
# Trust policy — allows EC2 service to assume this role
# ------------------------------------------------------------------
data "aws_iam_policy_document" "ec2_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# ------------------------------------------------------------------
# IAM Role
# ------------------------------------------------------------------
resource "aws_iam_role" "k8s_node_ecr_role" {
  name               = "k8s-node-ecr-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_trust.json

  tags = {
    Project = var.project_name
  }
}

# ------------------------------------------------------------------
# Attach AWS-managed read-only ECR policy
# ------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "ecr_readonly" {
  role       = aws_iam_role.k8s_node_ecr_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# ------------------------------------------------------------------
# Instance Profile (wraps the role so it can be attached to EC2)
# ------------------------------------------------------------------
resource "aws_iam_instance_profile" "k8s_node_ecr_profile" {
  name = "k8s-node-ecr-profile"
  role = aws_iam_role.k8s_node_ecr_role.name

  tags = {
    Project = var.project_name
  }
}
