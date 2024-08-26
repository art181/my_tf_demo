# infra/gcp/main.tf
terraform {
  cloud {
    organization = "art_rod_llc"
    workspaces {
       name = "gcp-infrastructure"
    }
  }
}

# 1. Create VPC
resource "google_compute_network" "prod-vpc" {
  name                    = "prod-vpc"
  auto_create_subnetworks = "false"
}

# 2. Create Internet Gateway
resource "google_compute_router" "my_router" {
  name    = "my-router"
  network = google_compute_network.prod-vpc.name
  region  = "us-west1"  # specify your region
}

resource "google_compute_router_nat" "my_nat" {
  name   = "my-nat"
  router = google_compute_router.my_router.name
  region = google_compute_router.my_router.region

  nat_ip_allocate_option = "AUTO_ONLY"

  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

# 3. Create Custom Route Table
# GCP does not require explicit route table resources for basic setups.
# The following route is automatically created when you attach a NAT gateway.

# 4. Create Subnet
resource "google_compute_subnetwork" "subnet-1" {
  name          = "subnet-1"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-west1"  # specify your region
  network       = google_compute_network.prod-vpc.name
}

# 5. Associate Subnet with Route Table
# No equivalent needed as GCP handles routing via the VPC and NAT configuration.

# 6. Create Firewall Rule (equivalent to Security Group) to allow port 22, 80, 443
resource "google_compute_firewall" "my_fw" {
  name    = "my-firewall"
  network = google_compute_network.prod-vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# 7. Create Network Interface (Equivalent to attaching it to an instance in GCP)
# No separate ENI resource is needed in GCP, this is handled directly in the instance configuration.

# 8. Assign a Static IP to the Network Interface
resource "google_compute_address" "my_eip" {
  name   = "my-eip"
  region = "us-west1"  # specify your region
}

# 9. Create Ubuntu Server and install/enable apache2
resource "google_compute_instance" "my_ubuntu" {
  name         = "my-ubuntu"
  machine_type = "e2-micro"
  zone         = "us-west1-a"  # specify your zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network    = google_compute_network.prod-vpc.id
    subnetwork = google_compute_subnetwork.subnet-1.id

    access_config {
      nat_ip = google_compute_address.my_eip.address
    }
  }

  metadata_startup_script = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y apache2
              sudo systemctl enable apache2
              sudo systemctl start apache2
              sudo bash -c 'echo This Would be your OWN Web Server on GCP! > /var/www/html/index.html'
            EOF

  tags = ["http-server", "https-server"]
}
