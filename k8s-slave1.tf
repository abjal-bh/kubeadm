resource "aws_instance" "k8s-slave1" {
  ami           = "ami-0603cbe34fd08cb81"
  instance_type = "t2.micro"
  key_name = "abs"
  subnet_id = "subnet-1a944371"
  security_groups = ["sg-001470d7a4e8d6f21"]
  tags = {
    Name = "k8s-1"
}
}