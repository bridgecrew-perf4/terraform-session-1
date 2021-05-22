module "s3_module" {
  # remote module
  source = "github.com/nazy67/terraform-session/modules/s3"
  # variables in module
  env = "qa"
}