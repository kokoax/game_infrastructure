data "aws_ssm_parameter" "ark_amzn2_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_key_pair" "access_ark_instance" {
  key_name   = "ark-instance-access-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDGZNv+xLdS6WTRQG/AogcKNxOqp7RAxbYPjNJ8UXnuN87K4Stz3AeFQuFdcfmbGBs1ju1FiEGnoNdMvlvPSr8YxDdwSOfBGLE8ZnhithcNZPpQJB1pWVJ/T8IvA+VOsigMyvSyvudIMX/ZqYgJUtH3dgngkh4LZ0kME69Hqp+VuDgCX4y1dI+6arCuXOWYoUACBOBXS1fakbz3XYeetMAdR594LMnfVHfroAGyLGn2gFpvxnlsGNkCgzpFrtfPUXVvNXl4aAxWAY1HR3lKCJI6gUtYzOOWNupqhBJh/f93rG8+Qg4O8W5F7A1uYhKkxFxDa/UJXs059G8o6Y1E4jMV y-tokoi@y-tokoi.voyagegroup.local"
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

resource "aws_spot_instance_request" "_ark_spot_instance_request" {
  ami           =	"ami-04370541afecb3d12"
  instance_type = "c5.large"
  subnet_id     = aws_subnet.ark.id
  spot_price = "0.1"
  security_groups = [aws_security_group.ark_security_group.id]
  key_name = aws_key_pair.access_ark_instance.id

  tags = {
    Name = "ark-spot-instance"
  }
}

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

