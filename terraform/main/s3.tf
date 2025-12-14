resource "aws_s3_bucket" "static_site" {
  bucket        = "mein-chatapp-static-${random_integer.suffix.id}"
  force_destroy = true

  tags = {
    Name = "chatapp-static"
  }
}

resource "random_integer" "suffix" {
  min = 10000
  max = 99999
}

resource "aws_s3_bucket_website_configuration" "static_site" {
  bucket = aws_s3_bucket.static_site.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}
