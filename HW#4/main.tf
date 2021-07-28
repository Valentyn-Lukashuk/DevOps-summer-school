terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  credentials = file("terraform_gcp_key.json")

  project = "graphic-chain-321011"
  region  = "europe-west1"
  zone    = "europe-west1-c"
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}


resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "e2-small"
  tags = ["http-server","https-server","externalssh"]
  metadata = {
    ssh-keys = "lukashuk:${file("~/.ssh/id_rsa.pub")}"
  }
  metadata_startup_script = file("apache_install.sh") 
  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20210720"
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.static.address
    }
  }
  #provisioner "remote-exec" {
  #  connection {
  #  host        = google_compute_address.static.address
  #  type        = "ssh"
  #  user        = var.user
  #  timeout     = "500s"
  #  private_key = file(var.privatekeypath)
  #}
  #inline = [
  #  "sudo apt update",
  #  "sudo apt install apache2 -y",
  #] 
  #}
  #depends_on = [ google_compute_firewall.firewall, google_compute_firewall.http-server, google_compute_firewall.https-server ]
}
resource "google_compute_firewall" "http-server" {
  name    = "default-allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

resource "google_compute_firewall" "firewall" {
  name = "gritfy-firewall-externalssh"
  network = "default"
  allow {
    protocol = "tcp"
    ports = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["externalssh"]
}


resource "google_compute_firewall" "https-server" {
  name    = "default-allow-https"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["https-server"]
}
resource "google_compute_address" "static" {
  name = "vm-public-address"
  project = "graphic-chain-321011"
  region  = "europe-west1"
  depends_on = [ google_compute_firewall.firewall]
}

