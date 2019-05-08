//output "ballancer_ip" {
//  value = "${google_compute_forwarding_rule.app_frontend.ip_address}"
//}

output "app_external_ip" {
value = "${module.app.app_external_ip}"
}
