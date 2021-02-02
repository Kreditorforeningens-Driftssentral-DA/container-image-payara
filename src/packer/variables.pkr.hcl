variable image_name {
  type    = string
  default = "local/payara"
}

variable image_tags {
  type    = list(string)
  default = ["dev"]
}

# ANSIBLE PLAYBOOK - PAYARA INSTALL
variable payara_version {
  type    = string
  default = "5.2020.7"
}

variable openjdk_version {
  type    = string
  default = "11"
}

# ANSIBLE PLAYBOOK - OS CONFIG
variable locale_name {
  type    = string
  default = "nb_NO ISO-8859-1"
}

variable locale_env {
  type    = string
  default = "nb_NO.ISO-8859-1"
}

variable locale_package {
  type    = string
  default = "language-pack-nb"
}

variable timezone_continent {
  type    = string
  default = "Europe"
}

variable timezone_city {
  type    = string
  default = "Oslo"
}

# ANSIBLE PLAYBOOK - PAYARA CONFIG
variable domain_name {
  type    = string
  default = "production"
}

variable asadmin_password {
  type    = string
  default = "Admin123"
}
