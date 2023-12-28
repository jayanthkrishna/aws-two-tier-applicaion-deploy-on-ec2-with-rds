
resource "aws_launch_template" "ec2-asg-launch-template" {
    image_id = "ami-0c7217cdde317cfec"
    instance_type = "t2.micro"
    key_name = "ec2-key-pair"
    vpc_security_group_ids = [var.server-sg-id]
    tags = {
        "Name"= "${var.project-name}-ec2-launch-remplate"
    }
    user_data = base64encode(file("${path.module}/userdata.sh"))
    
}

resource "aws_autoscaling_group" "asg-group" {
    name = "${var.project-name}-asg"
  launch_template {
    id = aws_launch_template.ec2-asg-launch-template.id
    version = "$Latest"
  }
  
  max_size = 4
  min_size = 2
  desired_capacity = 2

  vpc_zone_identifier = [ var.private_subnet1_id,var.private_subnet2_id ]

  target_group_arns = [ var.tg-arn ]
  
}
