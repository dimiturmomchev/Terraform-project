terraform {
  backend "s3" {
    bucket = "dimitar-momchev-bucket-state-test"
    key    = "my-terraform-project/ec2.tfstate"
    region = "eu-central-1"  
  }
}

provider "aws" {
  region = "eu-centarl-1"
}
