terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.6.0"
    }
  }
}

provider "google" {
  impersonate_service_account = "terraform-runner@project-37461d80-d5a2-4760-9d3.iam.gserviceaccount.com"
  project                     = var.project
}

resource "google_storage_bucket" "demo-bucket" {
  name                        = var.gcs_bucket_name
  location                    = var.location
  force_destroy               = true
  uniform_bucket_level_access = true


  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}
