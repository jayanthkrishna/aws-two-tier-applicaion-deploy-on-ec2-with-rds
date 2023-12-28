variable "vpc_cidr" {
    default = "10.1.0.0/16"
}
variable "public_subnet1" {
    default = "10.1.0.0/24"
}
variable "public_subnet2" {
    default = "10.1.1.0/24"
}
variable "private_subnet1" {
    default = "10.1.2.0/24"
}
variable "private_subnet2" {
    default = "10.1.3.0/24"
}
variable "project-name" {
    default = "aws-two-tier-app"
}