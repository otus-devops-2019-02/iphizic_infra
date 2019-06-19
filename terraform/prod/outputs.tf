//output "ballancer_ip" {
//  value = "${google_compute_forwarding_rule.app_frontend.ip_address}"
//}

output "app_external_ip" {
  value = "${module.app.external_ip}"
}

output "db_external_ip" {
  value = "${module.db.external_ip}"
}
