resource "aws_key_pair" "access_palworld_instance" {
  key_name   = "palworld-instance-access-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDGZNv+xLdS6WTRQG/AogcKNxOqp7RAxbYPjNJ8UXnuN87K4Stz3AeFQuFdcfmbGBs1ju1FiEGnoNdMvlvPSr8YxDdwSOfBGLE8ZnhithcNZPpQJB1pWVJ/T8IvA+VOsigMyvSyvudIMX/ZqYgJUtH3dgngkh4LZ0kME69Hqp+VuDgCX4y1dI+6arCuXOWYoUACBOBXS1fakbz3XYeetMAdR594LMnfVHfroAGyLGn2gFpvxnlsGNkCgzpFrtfPUXVvNXl4aAxWAY1HR3lKCJI6gUtYzOOWNupqhBJh/f93rG8+Qg4O8W5F7A1uYhKkxFxDa/UJXs059G8o6Y1E4jMV y-tokoi@y-tokoi.voyagegroup.local"
}

resource "aws_instance" "_palworld_ec2_instance" {
  ami           =	"ami-0611486aa63a5919d"
  instance_type = "m5.xlarge"
  subnet_id     = aws_subnet._palworld.id
  vpc_security_group_ids = [aws_security_group._palworld_security_group.id]
  key_name = aws_key_pair.access_palworld_instance.id
  iam_instance_profile = aws_iam_instance_profile.game_instance_profile.name

  root_block_device {
    volume_size = 20
  }

  tags = {
    Name = "palworld-instance"
  }
}

resource "aws_security_group" "_palworld_security_group" {
  name        = "palworld_security_group"
  description = "palworld_security_group"
  vpc_id      = aws_vpc.game.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8211
    to_port = 8211
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 外に出るアクセスは全て許可する
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

