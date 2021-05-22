module "ec2_module" {
  source = "../../modules/ec2"

  env = "dev"
  instance_type = "t2/micro"
  ami = "ami-0742b4e673072066f"
}

