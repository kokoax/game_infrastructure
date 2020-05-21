data aws_ssm_parameter amzn2_ami {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_key_pair" "access_7dtd_instance" {
  key_name   = "7dtd-instance-access-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCnZ0XLXWVjFcQ90FHlDpMt3Z99OPEBt290Y5aA9tBA/OxL7yxo4ORLwh0tMNQ2CrQ8mriTd7+y85WiwCmKGxxVdWlSEVWtT7SCjlKrCUXnzZqv1PWJXlx5TZ5IbJ5SFDUp90Tv2SnuWopdOYRWD2gzOj7Tj8k39ivff3W3z7bUFfOhba0uTEhKxlvgrbRxRLBNYJuNErrvh4TAtYe3b0+CKAnbX4PAxMzPH9g6c2DRQbSsUTbmF4KwzdBxCng3wRRIFaB985nu3QP6W8Jzv1smuD2MAySbKP5YW5wEGgcfMk9o2p7TLfFeDgmjvO4ScnHNj9pQJXftuLeLIIRKXkB5egZ69FaLA3gtPXyCHzqJW2/96tGWnaChwwD8aCA4Uqco+KPFoXQZD4jQEHafxjgf5iJ9D2NPT8vppAwBu5lppWWZVx2LljxS1MLiHEWneusCcDoVoNs5ZfN83fIRB03YYyl7QngsWQO9hdpLg6s/rNWP8huGobzENDzPv3ao6dM= y-tokoi@y-tokoi.voyagegroup.local"
}

resource "aws_ebs_volume" "volume" {
  availability_zone = "ap-northeast-1d"
  size = 20

  tags = {
    Name = "7dtd-volume"
  }
}

# Spot Instanceには起動前にEBSをアタッチできないので形だけ残しておく
# 実際にはprovisioning時にcliからアタッチ実施している
# resource "aws_volume_attachment" "ebs_attach" {
#   device_name = "/dev/sdh"
#   volume_id = aws_ebs_volume.volume.id
#   instance_id = aws_spot_instance_request._7dtd_spot_instance_request.id
# }

resource "aws_spot_instance_request" "_7dtd_spot_instance_request" {
  ami           =	"ami-016edb6ab84556084"
  instance_type = "c5.large"
  subnet_id     = aws_subnet.public.id
  spot_price = "0.1"
  security_groups = [aws_security_group._7dtd_security_group.id]
  key_name = aws_key_pair.access_7dtd_instance.id

  tags = {
    Name = "7dtd-spot-instance"
  }
}

resource "aws_security_group" "_7dtd_security_group" {
  name        = "7dtd_security_group"
  description = "for instance ssh"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 26900
    to_port = 26900
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 26900
    to_port = 26900
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 26901
    to_port = 26901
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 26902
    to_port = 26902
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 26903
    to_port = 26903
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

