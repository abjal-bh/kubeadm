terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile    = "default"
  region     = "us-east-2"
}
resource "aws_instance" "k8s-master" {
  ami           = "ami-0603cbe34fd08cb81"
  instance_type = "t2.medium"
  key_name = "abs"
  subnet_id = "subnet-1a944371"
  security_groups = ["sg-001470d7a4e8d6f21"]
  tags = {
    Name = "k8s-master"
}
}