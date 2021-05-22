module "ec2_module" {
  # local module
  source = "../../modules/ec2"
  # module variables
  env           = "qa"
  instance_type = "t2.micro"
  ami           = "ami-0742b4e673072066f"
}

