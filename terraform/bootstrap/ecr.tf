resource "aws_ecr_repository" "app" {
  name = "sveltekit-chatapp"

  image_scanning_configuration {
    scan_on_push = true
  }
}
