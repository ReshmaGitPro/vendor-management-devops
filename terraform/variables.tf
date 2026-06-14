variable "aws_region" {
  description = "AWS Region"
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 Instance Type"
  default     = "t3.micro"
}

variable "ecr_repositories" {
  description = "List of ECR repositories"
  type        = list(string)

  default = [
    "reshma-frontend-repository",
    "reshma-backend-repository"
  ]
}