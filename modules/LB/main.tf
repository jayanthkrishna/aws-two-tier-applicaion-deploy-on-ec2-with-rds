resource "aws_lb" "web-ec2-alb" {
  name = "web-ec2-alb"
  internal = false

  load_balancer_type = "application"
  security_groups = [ var.lb_sg_id ]

  subnets = [ var.public_subnet1_id, var.public_subnet2_id]

  tags = {
    "Name"="web-ec2-alb"
  }
}

resource "aws_lb_target_group" "mytg" {
    name="TG"
    port = 80
    protocol = "HTTP"
    vpc_id = var.vpc_id

    health_check {
      path = "/"
      port = "traffic-port"
    }
}

resource "aws_lb_listener" "lb-listener" {
  load_balancer_arn = aws_lb.web-ec2-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mytg.arn
  }
}


