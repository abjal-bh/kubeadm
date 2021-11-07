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
  ami           = "ami-01cc34ab2709337aa"
  instance_type = "t2.medium"
  key_name = "abs"
  subnet_id = "subnet-5094a31c"
  security_groups = ["sg-c58eeb8f"]
  tags = {
    Name = "k8s-master"
}
}
