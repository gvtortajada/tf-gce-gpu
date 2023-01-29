variable "region" {
  description = "The regions"
  default     = "us-central1"
}

variable "zone" {
  description = "The zone"
  default     = "us-central1-a"
}

variable "ip_cidr_range" {
  default = "10.128.0.0/24"
}

variable "vpc_network" {
  description = "The VPC network"
  default     = "network"
}

variable "vpc_sub_network" {
  description = "The subnetwork"
  default     = "subnet"
}