variable "project_id" {}
variable "region" {}
variable "vpc_network" {}
variable "vpc_sub_network" {}
variable "ip_cidr_range" {}

resource "google_compute_network" "vpc_network" {
  project                 = var.project_id
  name                    = var.vpc_network
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "vpc_sub_network" {
  name                     = var.vpc_sub_network
  project                  = var.project_id
  ip_cidr_range            = var.ip_cidr_range
  region                   = var.region
  network                  = google_compute_network.vpc_network.id
  private_ip_google_access = true
}

resource "google_compute_route" "default" {
  project          = var.project_id
  name             = "default-internet-gateway"
  dest_range       = "0.0.0.0/0"
  network          = google_compute_network.vpc_network.name
  next_hop_gateway = "default-internet-gateway"
  priority         = 1000
}

resource "google_compute_router" "router" {
  name    = "my-router"
  project = var.project_id
  region  = google_compute_subnetwork.vpc_sub_network.region
  network = google_compute_network.vpc_network.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat" {
  name                               = "my-router-nat"
  project                            = var.project_id
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

output "vpc_network" {
  value = google_compute_network.vpc_network
}

output "vpc_sub_network" {
  value = google_compute_subnetwork.vpc_sub_network
}
