
resource "aws_db_subnet_group" "main" {
  name = "main-db-subnet-group"
  subnet_ids = [
    aws_subnet.private.id,
    aws_subnet.private_b.id,
  ]
  tags = { Name = "main-db-subnet-group" }
}


resource "aws_db_instance" "mysql" {
  identifier     = "chatapp-mysql"  

  engine         = "mysql"      
  engine_version = "8.0"            

  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  port                   = 3306            

  publicly_accessible = false
  multi_az            = false
  storage_encrypted   = true
  skip_final_snapshot = true

  tags = { Name = "chatapp-mysql" }
}
