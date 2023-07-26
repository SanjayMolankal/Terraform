#Saving state file on remote
terraform {
  cloud {
    organization = "Infra-Terraform-01"

    workspaces {
      name = "Terraform-test"
    }
  }
}
