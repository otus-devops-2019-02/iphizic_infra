variable project {
  description = "Project ID"
}

variable region {
  description = "Region"

  # Значение по умолчанию
  default = "europe-west4-b"
}

variable public_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}

variable disk_image {
  description = "Disk image"
}

variable private_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}

variable app_zone {
  description = "Zone"

  # Значение по умолчанию
  default = "*"
}
