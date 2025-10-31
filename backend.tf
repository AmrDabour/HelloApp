terraform {
  backend "s3" {
    bucket       = "terraformamr5312"
    key          = "eks/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

