resource "google_compute_instance" "db" {
  count        = 1
  name         = "reddit-db-${count.index}"
  machine_type = "g1-small"
  zone         = "${var.app_zone}"
  tags         = ["reddit-db"]

  metadata {
    # путь до публичного ключа
    ssh-keys = "iphizic:${file(var.public_key_path)}\nappuser:${file(var.public_key_path)}\nappuser2:${file(var.public_key_path)}"
  }

  # определение загрузочного диска
  boot_disk {
    initialize_params {
      image = "${var.db_disk_image}"
    }
  }

  # определение сетевого интерфейса
  network_interface {
    # сеть, к которой присоединить данный интерфейс
    network = "default"

    # использовать ephemeral IP для доступа из Интернет
    access_config = {}
  }

}

resource "google_compute_firewall" "firewall_mongj" {
  name = "allow-mongo-default"

  # Название сети, в которой действует правило
  network = "default"

  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["27017"]
  }

  # Правило применимо для инстансов с перечисленными тэгами
  target_tags = ["reddit-db"]
  source_tags = ["reddit-app"]
}