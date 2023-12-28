
module "vpc-networking" {
  source = "./modules/VPC-Networking"

  vpc_cidr = var.vpc_cidr
  public_subnet1 = var.public_subnet1
  public_subnet2 = var.public_subnet2
  private_subnet1 = var.private_subnet1
  private_subnet2 = var.private_subnet2
  project-name = var.project-name

}

module "sg" {
    source = "./modules/Security-Group"
    vpc_id = module.vpc-networking.vpc_id
    project-name = var.project-name

  
}

module "lb" {
  source = "./modules/LB"
  lb_sg_id = module.sg.lb-sg-id
  vpc_id = module.vpc-networking.vpc_id
  public_subnet1_id = module.vpc-networking.public_subnet1_id
  public_subnet2_id = module.vpc-networking.public_subnet2_id
}

module "asg" {
    depends_on = [ module.vpc-networking,module.sg,module.lb ]
    source = "./modules/ASG"
    project-name = var.project-name
    server-sg-id = module.sg.server-ec2-sg-id
    private_subnet1_id = module.vpc-networking.private_subnet1_id
    private_subnet2_id = module.vpc-networking.private_subnet2_id
    tg-arn = module.lb.tg-arn
}

