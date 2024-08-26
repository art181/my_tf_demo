terraform {
  backend "remote" {
    organization = "art_rod_llc"
    workspaces {
      name = "aws-production"
    }
  }
}