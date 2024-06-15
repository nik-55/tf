resource "aws_s3_bucket" "remote_dev_s3" {
  bucket = "nikhil-121-remote-dev-s3"

  tags = {
    Name = "dev"
  }
}
