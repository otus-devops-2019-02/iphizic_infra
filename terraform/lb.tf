resource "google_compute_target_pool" "lb_pool" {
  name = "lb-pool"

  instances = [
    "${google_compute_instance.app.*.self_link}",
  ]

  health_checks = [
    "${google_compute_http_health_check.appcheck.name}",
  ]
}

resource "google_compute_forwarding_rule" "app_frontend" {
  name = "app-frontend"

  target = "${google_compute_target_pool.lb_pool.self_link}"

  port_range = "9292"
}

resource "google_compute_http_health_check" "appcheck" {
  name               = "appcheck"
  port               = "9292"
  timeout_sec        = 1
  check_interval_sec = 1
}
