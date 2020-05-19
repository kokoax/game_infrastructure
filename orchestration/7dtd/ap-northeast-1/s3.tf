resource "aws_s3_bucket" "buckup" {
  bucket = "7dtd-buckup"
  acl = "private"

  tags = {
    Name = "7dtd buckup bucket"
  }
}
