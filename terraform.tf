terraform {
  backend "remote" {
    organization = "ortaleb-tf"

    workspaces {
      name = "ortaleb-wsp"
    }
  }
}
