output "instance_id" {
  description = "The ID of the bastion VM instance."
  value       = google_compute_instance.bastion.id
}

output "instance_name" {
  description = "The name of the bastion VM instance."
  value       = google_compute_instance.bastion.name
}

output "private_ip" {
  description = "The internal private IP of the bastion VM."
  value       = google_compute_instance.bastion.network_interface[0].network_ip
}

output "service_account_email" {
  description = "The email of the bastion service account."
  value       = google_service_account.bastion_sa.email
}

output "ssh_iap_command" {
  description = "Convenient gcloud CLI command to SSH into the private bastion via IAP tunnel."
  value       = "gcloud compute ssh ${google_compute_instance.bastion.name} --zone ${google_compute_instance.bastion.zone} --project ${google_compute_instance.bastion.project} --tunnel-through-iap"
}
