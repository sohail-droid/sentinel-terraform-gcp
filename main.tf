provider "google" {
  project = "training-2024-batch"
  region  = "us-central1"
}

#vpc networks
resource "google_compute_network" "vpc_network" {
  project                 = "training-2024-batch"
  name                    = "vpc-network"
  auto_create_subnetworks = false
}


# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "mana-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.id
}

# Firewall rule - Allow SSH
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22","80","443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["sohail-tag"]
}


#creating a compute instance vm
resource "google_compute_instance" "default" {
  name         = "my-instance"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  tags = ["smd-tag", "sohail-tag"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "NVME"
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    foo = "smd-sohail-metadata"
  }

  metadata_startup_script = "echo hi > /test.txt"
}


#creating a storage bucket
resource "google_storage_bucket" "demo_bucket" {
  name     = "training-2024-batch-demo-bucket"
  location = "us-central1"

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  labels = {
    environment = "development-sohail"
    managed_by  = "terraform"
  }

  lifecycle_rule {
    condition {
      age = 7
    }
    action {
      type = "Delete"
    }
  }
}

