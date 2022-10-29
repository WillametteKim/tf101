resource "aws_lb" "willamettealb" {
  name               = "t101-alb"
  load_balancer_type = "application"
  subnets            = [aws_subnet.willamettesubnet1.id, aws_subnet.willamettesubnet2.id]
  security_groups    = [aws_security_group.willamettesg.id]

  tags = {
    Name = "t101-alb"
  }
}

resource "aws_lb_listener" "willamettehttp" {
  load_balancer_arn = aws_lb.willamettealb.arn
  port              = 80
  protocol          = "HTTP"

  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found - T.T T101 Study"
      status_code  = 404
    }
  }
}

resource "aws_lb_target_group" "willamettealbtg" {
  name     = "t101-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.willamettevpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-299"
    interval            = 5
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "willamettealbrule" {
  listener_arn = aws_lb_listener.willamettehttp.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.willamettealbtg.arn
  }
}


output "willamettealb_dns" {
  value       = aws_lb.willamettealb.dns_name
  description = "The DNS Address of the ALB"
}
