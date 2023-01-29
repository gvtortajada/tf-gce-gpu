variable "project_id" {}
variable "region" {}
variable "zone" {}
variable "vpc_network" {}
variable "vpc_sub_network" {}

resource "google_compute_disk" "gce_instance_disk" {
  image                     = "https://www.googleapis.com/compute/v1/projects/debian-cloud/global/images/debian-11-bullseye-v20221206"
  name                      = "instance-1"
  physical_block_size_bytes = "4096"
  project                   = var.project_id
  provisioned_iops          = "0"
  size                      = "10"
  type                      = "pd-balanced"
  zone                      = var.zone
}


resource "google_compute_instance" "gce_instance" {

  boot_disk {
    auto_delete = "true"
    device_name = "instance-1"
    mode        = "READ_WRITE"
    source      = google_compute_disk.gce_instance_disk.id
  }

  guest_accelerator {
    count = "1"
    type  = "https://www.googleapis.com/compute/v1/projects/${var.project_id}/zones/${var.zone}/acceleratorTypes/nvidia-tesla-a100"
  }

  machine_type = "a2-highgpu-1g"

  min_cpu_platform = "Intel Cascade Lake"
  name             = "instance-1"

  network_interface {
    network = var.vpc_network.id
    subnetwork         = var.vpc_sub_network.id
    subnetwork_project = var.project_id
  }

  project = var.project_id

  reservation_affinity {
    type = "ANY_RESERVATION"
  }

  scheduling {
    automatic_restart   = "true"
    min_node_cpus       = "0"
    on_host_maintenance = "TERMINATE"
    preemptible         = "false"
    provisioning_model  = "STANDARD"
  }

  shielded_instance_config {
    enable_integrity_monitoring = "true"
    enable_secure_boot          = "true"
    enable_vtpm                 = "true"
  }

  tags = ["gpu"]
  zone = var.zone
}
