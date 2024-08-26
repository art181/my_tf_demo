terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"  # Use the latest 4.x version
    }
  }
}

# Configure the Google Cloud Provider
provider "google" {
  project     = var.gcp_project_id
  region      = var.gcp_region
  zone        = var.gcp_zone
  credentials = var.gcp_credentials
}