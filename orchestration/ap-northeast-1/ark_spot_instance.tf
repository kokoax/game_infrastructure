data "aws_ssm_parameter" "ark_amzn2_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_key_pair" "access_ark_instance" {
  key_name   = "ark-instance-access-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCnZ0XLXWVjFcQ90FHlDpMt3Z99OPEBt290Y5aA9tBA/OxL7yxo4ORLwh0tMNQ2CrQ8mriTd7+y85WiwCmKGxxVdWlSEVWtT7SCjlKrCUXnzZqv1PWJXlx5TZ5IbJ5SFDUp90Tv2SnuWopdOYRWD2gzOj7Tj8k39ivff3W3z7bUFfOhba0uTEhKxlvgrbRxRLBNYJuNErrvh4TAtYe3b0+CKAnbX4PAxMzPH9g6c2DRQbSsUTbmF4KwzdBxCng3wRRIFaB985nu3QP6W8Jzv1smuD2MAySbKP5YW5wEGgcfMk9o2p7TLfFeDgmjvO4ScnHNj9pQJXftuLeLIIRKXkB5egZ69FaLA3gtPXyCHzqJW2/96tGWnaChwwD8aCA4Uqco+KPFoXQZD4jQEHafxjgf5iJ9D2NPT8vppAwBu5lppWWZVx2LljxS1MLiHEWneusCcDoVoNs5ZfN83fIRB03YYyl7QngsWQO9hdpLg6s/rNWP8huGobzENDzPv3ao6dM= y-tokoi@y-tokoi.voyagegroup.local"
}

resource "aws_ebs_volume" "ark" {
  availability_zone = "ap-northeast-1d"
  size = 20

  tags = {
    Name = "ark-volume"
  }
}

# Spot Instanceには起動前にEBSをアタッチできないので形だけ残しておく
# 実際にはprovisioning時にcliからアタッチ実施している
# resource "aws_volume_attachment" "ebs_attach" {
#   device_name = "/dev/sdh"
#   volume_id = aws_ebs_volume.ark.id
#   instance_id = aws_spot_instance_request._ark_spot_instance_request.id
# }

#resource "aws_spot_instance_request" "_ark_spot_instance_request" {
#  ami           =	"ami-04370541afecb3d12"
#  instance_type = "c5.large"
#  subnet_id     = aws_subnet.ark.id
#  spot_price = "0.1"
#  security_groups = [aws_security_group.ark_security_group.id]
#  key_name = aws_key_pair.access_ark_instance.id
#
#  tags = {
#    Name = "ark-spot-instance"
#  }
#}

resource "aws_security_group" "ark_security_group" {
  name        = "ark_security_group"
  description = "for instance ssh"
  vpc_id      = aws_vpc.game.id

  ingress {
    from_port = 22
    to_port = 22
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
    from_port = 7777
    to_port = 7777
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    from_port = 7777
    to_port = 7777
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 7778
    to_port = 7778
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 7778
    to_port = 7778
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 27015
    to_port = 27015
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 27015
    to_port = 27015
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 32330
    to_port = 32330
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 32330
    to_port = 32330
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

