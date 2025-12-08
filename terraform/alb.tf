resource "aws_lb" "chatapp" {
  name               = "chatapp-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public.id, aws_subnet.public_b.id] # 2 AZs!
}


# Target Group
resource "aws_lb_target_group" "chatapp" {
  name        = "chatapp-tg"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip" # ← FIX FÜR FARGATE + awsvpc!

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}


# ALB Listener + Target Group
resource "aws_lb_listener" "chatapp" {
  load_balancer_arn = aws_lb.chatapp.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.chatapp.arn
  }
}