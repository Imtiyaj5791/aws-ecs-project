
data "aws_ecr_repository" "app" {
  name = "myapp-dev"
}

module "ecs" {
  source = "../../modules/ecs"

  cluster_name = "myapp-dev"
  environment  = "dev"

  vpc_id = data.terraform_remote_state.platform.outputs.vpc_id

  public_subnet_ids = [
    data.terraform_remote_state.platform.outputs.public_subnet_ids["dev"],
    data.terraform_remote_state.platform.outputs.public_subnet_2_ids["dev"]
  ]

  image_uri = "${data.aws_ecr_repository.app.repository_url}:${var.image_tag}"

  container_port = 3000
  task_cpu       = 256
  task_memory    = 512
}
