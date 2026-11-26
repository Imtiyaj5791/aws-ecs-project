variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}



variable "availability_zones" {
  description = "Availability zones for subnets"
  type        = list(string)
}

variable "environment_subnets" {
  description = "Subnet CIDRs for each environment across two AZs"

  type = map(object({
    public    = string
    private   = string
    public_2  = string
    private_2 = string
  }))
}