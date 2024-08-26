# Root hcp.tf file
terraform {
  cloud {
    organization = "art_rod_llc"
    workspaces {
      tags = ["managed-by-terraform"]
    }
  }
}
