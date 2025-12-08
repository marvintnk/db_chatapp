data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_instance" "db_tester" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public.id
  # EC2 nutzt jetzt test_ec2_sg
  vpc_security_group_ids = [
    aws_security_group.ecs_service_sg.id,  # ← ECS SG (für DB-Zugriff!)
    aws_security_group.web_sg.id           # ← SSH!
  ]



  associate_public_ip_address = true
  key_name = "terraform-ec2-key"

  tags = { Name = "mysql-nc-tester" }
}

resource "aws_security_group" "test_ec2_sg" {
  name        = "test-ec2-sg"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


