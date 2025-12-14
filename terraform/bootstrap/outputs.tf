output "ecr_repository_url" {
  value = aws_ecr_repository.sveltekit_app.repository_url
}

output "tf_state_bucket" {
  value       = aws_s3_bucket.tf_state.bucket
  description = "Terraform remote state bucket name"
}

output "tf_state_dynamodb_table" {
  value       = aws_dynamodb_table.tf_locks.name
  description = "Terraform state lock table"
}

output "aws_region" {
  value = var.aws_region
}
