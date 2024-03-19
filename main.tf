terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.21.0"
    }
  }
}

provider "google" {
  project = "theta-decker-378908"

  # NOTE: free GCE 'e2-micro' VM instances are only available in some regions
  # https://cloud.google.com/free/docs/free-cloud-features#free-tier-usage-limits
  region = "us-east1"

  # gcloud compute zones list --filter=region=us-east1
  zone   = "us-east1-b"
}

# very basic VM
data "google_compute_image" "freebsd-img" {
  # gcloud compute images list --project freebsd-org-cloud-dev --no-standard-images
  family  = "freebsd-14-0"
  project = "freebsd-org-cloud-dev"
}

resource "google_compute_instance" "varian-test" {
  name         = "varian-test"
  machine_type = "e2-micro" # only machine type available for free

  boot_disk {
    initialize_params {
      image = data.google_compute_image.freebsd-img.self_link
    }
  }

  network_interface {
    network = "default"

    access_config {
      # allow access from anywhere, this automatically assigns a public IP
    }
  }

  # i'd create a separate service account for this VM in production or anywhere else it'd matter
}
