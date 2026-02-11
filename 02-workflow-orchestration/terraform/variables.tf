variable "project" {
  description = "Project"
  default     = "project-37461d80-d5a2-4760-9d3"
}

variable "region" {
  description = "Region"
  default     = "us-central1"
}

variable "location" {
  description = "Project Location"
  default     = "US"
}

variable "bq_dataset_name" {
  description = "NY Taxi Data"
  default     = "ny_taxi"
}

variable "gcs_bucket_name" {
  description = "Kestra GCP Demo Bucket"
  default     = "project-37461d80-d5a2-4760-9d3-kestra-demo-bucket"
}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}
