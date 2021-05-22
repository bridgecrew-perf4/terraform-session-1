module "s3_module" {
  # remote module
  source = "github.com/nazy67/terraform-session/modules/s3"
  # variables in module
  env = "dev"
}

module "s3_module_oregon" {
  # remote module
  source = "github.com/nazy67/terraform-session/modules/s3"
  # variables in module
  env = "dev1"

  provider = {
    aws = aws.oregon
   }
}