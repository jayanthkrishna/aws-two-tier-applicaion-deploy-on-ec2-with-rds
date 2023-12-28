terraform {
  backend "s3" {
    bucket = "jayanth-terraform-projects-tfstatefile-bucket"
    key    = "aws-two-tier-applicaion-deploy-on-ec2-with-rds/terraform.tfstate"
    region = "ap-south-1"
  }
}
