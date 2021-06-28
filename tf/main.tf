terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  credentials = file("terraform-sa-key.json")
  project     = "flask-app-318214"
  region      = "europe-west3"
  zone        = "europe-west3-a"
}

# ip address
resource "google_compute_address" "ip_address" {
  name = "flask-app-ip"
}

# network
resource "google_compute_network" "vpc_network" {
  name = "flask-app-vpc-network"
}

# firewall rule
resource "google_compute_firewall" "allow_http_ssh" {
  name    = "flask-app-firewall"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }
  source_ranges = ["0.0.0.0/0"]
}

# os image
data "google_compute_image" "vm_image" {
  family  = "cos-89-lts"
  project = "cos-cloud"
}

# compute engine instance
resource "google_compute_instance" "vm" {
  name         = "flask-app-vm"
  machine_type = "e2-micro"
  zone         = "europe-west3-a"

  boot_disk {
    initialize_params {
      image = data.google_compute_image.vm_image.self_link
    }
  }
  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
      nat_ip = google_compute_address.ip_address.address
    }
  }
  service_account {
    scopes = ["storage-ro"]
  }
}