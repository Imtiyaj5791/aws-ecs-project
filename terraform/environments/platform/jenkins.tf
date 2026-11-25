data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "jenkins" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.medium"
  subnet_id              = module.vpc.public_subnet_ids["platform"]
  vpc_security_group_ids = [aws_security_group.jenkins.id]

  user_data = file("${path.module}/jenkins-userdata.sh")

  iam_instance_profile = aws_iam_instance_profile.jenkins.name

  associate_public_ip_address = true

  key_name = aws_key_pair.jenkins.key_name

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name        = "jenkins-server"
    Environment = "platform"
  }
}