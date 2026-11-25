module "ecr" {
  source = "../../modules/ecr"

  repository_name = "myapp-dev"
  environment     = "dev"
}