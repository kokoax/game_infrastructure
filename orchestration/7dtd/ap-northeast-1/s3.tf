resource "aws_s3_bucket" "buckup" {
  bucket = "7dtd-backup"
  acl = "private"

  tags = {
    Name = "7dtd buckup bucket"
  }
}

resource "aws_s3_bucket_object" "Data_folder" {
  bucket = aws_s3_bucket.buckup.id
  key    = "Data/"
}

resource "aws_s3_bucket_object" "Save_folder" {
  bucket = aws_s3_bucket.buckup.id
  key    = "Saves/"
}
