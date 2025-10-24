terraform {
  backend "s3" {
    bucket       = "hello-devops-production-terraform-state"
    key          = "eks/terraform.tfstate"
    region       = "eu-west-1"
    encrypt      = true
    use_lockfile = true
  }
}

