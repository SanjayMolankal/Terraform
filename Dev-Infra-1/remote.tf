#Saving state file on remote
terraform {
  cloud {
    organization = "Infra-terra-new-2"

    workspaces {
      name = "Wonder-Siri"
    }
  }
}
