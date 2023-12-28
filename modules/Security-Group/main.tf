resource "aws_security_group" "server-ec2-sg" {
    vpc_id = var.vpc_id

    ingress {
        description      = "HTTP"
        from_port        = 80
        to_port          = 80
        protocol         = "tcp"
        security_groups = [ aws_security_group.lb-sg.id ]
        
    }
    ingress {
        description = "SSH from bastion host"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = [ aws_security_group.bastion-ec2-sg.id ]
        

    }
    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    
    }

     tags = {
        "Name"= "${var.project-name}-server-ec2-sg"
    }
  
}

resource "aws_security_group" "bastion-ec2-sg" {
    vpc_id = var.vpc_id
    ingress {
        description = "SSH from bastion host"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }
    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    
    }
    tags = {
        "Name"= "${var.project-name}-bastion-ec2-sg"
    }
  
}

resource "aws_security_group" "lb-sg" {
    vpc_id = var.vpc_id

    ingress {
        description      = "HTTP"
        from_port        = 80
        to_port          = 80
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        
    }
    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    
    }


}