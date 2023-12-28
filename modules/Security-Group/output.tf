output "server-ec2-sg-id" {
  value = aws_security_group.server-ec2-sg.id
}

output "bastion-sg-id" {
  value = aws_security_group.bastion-ec2-sg.id
}

output "lb-sg-id" {
    value = aws_security_group.lb-sg.id
  
}