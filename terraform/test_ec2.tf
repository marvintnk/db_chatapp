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
    aws_security_group.test_ec2_sg.id,  # ← EIGENE SG für Test-EC2 + SSH
    aws_security_group.ecs_service_sg.id
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

# Neue Regel: Test-EC2 SG → MySQL 3306
resource "aws_security_group_rule" "test_ec2_to_mysql" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db_sg.id
  source_security_group_id = aws_security_group.test_ec2_sg.id  # ← Test-EC2 SG!
  description              = "Test-EC2 to MySQL"
}


resource "aws_security_group_rule" "web_sg_to_mysql" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db_sg.id
  source_security_group_id = aws_security_group.web_sg.id  # ← WEB SG!
  description              = "Test-EC2 to MySQL"
}


