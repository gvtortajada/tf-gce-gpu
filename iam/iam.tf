variable "project_id" {}

resource "google_project_organization_policy" "requireOsLogin" {
  project     = var.project_id
  constraint = "compute.requireOsLogin"
 
  boolean_policy {
    enforced = false
  }
}

resource "google_project_organization_policy" "requireShieldedVm" {
  project     = var.project_id
  constraint = "compute.requireShieldedVm"
 
  boolean_policy {
    enforced = false
  }
}