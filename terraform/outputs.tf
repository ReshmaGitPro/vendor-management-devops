output "frontend_repo_url" {
  value = aws_ecr_repository.repositories["reshma-frontend-repository"].repository_url
}

output "backend_repo_url" {
  value = aws_ecr_repository.repositories["reshma-backend-repository"].repository_url
}

output "ec2_public_ip" {
  value = aws_instance.web.public_ip
}

output "public_dns" {
  value = aws_instance.web.public_dns
}