variable "instance_name" {
  description = "Value of the Name label for the GCP instance"
  type        = string
  default     = "example-app-server-instance"
}

variable "gcp_project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "gcp_credentials" {
  description = "GCP credentials JSON"
  type        = string
  sensitive   = true
}

variable "gcp_region" {
  description = "GCP region"
  type        = string
  default     = "us-west1"
}

variable "gcp_zone" {
  description = "GCP zone"
  type        = string
  default     = "us-west1-a"
}