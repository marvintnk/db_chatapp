########################
# ALB
########################
resource "aws_lb" "chatapp" {
  name               = "chatapp-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public.id, aws_subnet.public_b.id]
  
  # IPv6 aktivieren
  ip_address_type = "dualstack"  # ← dualstack = IPv4 + IPv6
}

########################
# Target Group
########################
resource "aws_lb_target_group" "chatapp" {
  name        = "chatapp-tg"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-499"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}

########################
# Security Group (IPv6 Regeln hinzufügen)
########################
resource "aws_security_group_rule" "alb_allow_ipv6_http" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.alb_sg.id
  cidr_blocks              = []       # IPv4 leer lassen
  ipv6_cidr_blocks         = ["::/0"] # IPv6 erlauben
}

resource "aws_security_group_rule" "alb_allow_ipv6_https" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.alb_sg.id
  cidr_blocks              = []
  ipv6_cidr_blocks         = ["::/0"]
}

########################
# HTTP → HTTPS Redirect
########################
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.chatapp.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

########################
# HTTPS Listener
########################
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.chatapp.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = "arn:aws:acm:eu-central-1:942849037433:certificate/f4449253-ea16-4ba8-b7d9-42a74d71fb6e"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.chatapp.arn
  }
}
