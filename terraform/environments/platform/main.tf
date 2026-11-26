module "vpc" {
  source = "../../modules/vpc"

  vpc_name = "shared-platform-vpc"
  vpc_cidr = "10.0.0.0/16"

  availability_zones = [
    "ap-south-1a",
    "ap-south-1b"
  ]

  environment_subnets = {
    platform = {
      public    = "10.0.1.0/24"
      private   = "10.0.11.0/24"
      public_2  = "10.0.5.0/24"
      private_2 = "10.0.15.0/24"
    }

    dev = {
      public    = "10.0.2.0/24"
      private   = "10.0.12.0/24"
      public_2  = "10.0.6.0/24"
      private_2 = "10.0.16.0/24"
    }

    uat = {
      public    = "10.0.3.0/24"
      private   = "10.0.13.0/24"
      public_2  = "10.0.7.0/24"
      private_2 = "10.0.17.0/24"
    }

    prod = {
      public    = "10.0.4.0/24"
      private   = "10.0.14.0/24"
      public_2  = "10.0.8.0/24"
      private_2 = "10.0.18.0/24"
    }
  }
}