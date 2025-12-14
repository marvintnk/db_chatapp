resource "aws_ecr_repository" "sveltekit_app" {
  name                 = "sveltekit-chatapp"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "sveltekit-chatapp-ecr"
  }
}