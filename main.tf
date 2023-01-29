provider "google" {
}

terraform {
  backend "gcs" {}
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.40.0"
    }
  }
}

variable "project_id" {
}

data "google_project" "project" {
  project_id = var.project_id
}

module "apis" {
  source     = "./apis"
  project_id = var.project_id
}

module "iam" {
  source     = "./iam"
  project_id = var.project_id
  depends_on = [
    module.apis
  ]
}

module "network" {
  source          = "./network"
  project_id      = var.project_id
  region          = var.region
  vpc_network     = var.vpc_network
  vpc_sub_network = var.vpc_sub_network
  ip_cidr_range   = var.ip_cidr_range
  depends_on = [
    module.apis
  ]
}

module "gce" {
  source          = "./gce"
  project_id      = var.project_id
  region          = var.region
  zone            = var.zone
  vpc_network     = module.network.vpc_network
  vpc_sub_network = module.network.vpc_sub_network
  depends_on = [
    module.apis,
    module.network
  ]
}
