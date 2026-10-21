
terraform {
  backend "s3" {
    bucket       = "project03-tfstate-a1"
    key          = "project03/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}
