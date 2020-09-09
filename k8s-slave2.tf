resource "aws_instance" "k8s-slave2" {
  ami           = "ami-0603cbe34fd08cb81"
  instance_type = "t2.micro"
  key_name = "abs"
  subnet_id = "subnet-482c2132"
  security_groups = ["sg-001470d7a4e8d6f21"]
  tags = {
    Name = "k8s-2"
}
}