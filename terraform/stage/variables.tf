variable project {
  description = "Project ID"
}

variable region {
  description = "Region"

  # Значение по умолчанию
  default = "europe-west4"
}

variable public_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}

variable app_disk_image {
  description = "Disk image"
}

variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-db-base"
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

variable source_ranges {
  description = "Zone for ssh login"

  # Значение по умолчанию
  default = "0.0.0.0/0"
}
