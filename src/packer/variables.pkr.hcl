variable docker_image_name {
  type    = string
  default = "local/payara"
}

variable docker_image_tags {
  type    = list(string)
  default = ["dev"]
}

# container repository push
variable docker_login_username {
  type    = string
  default = "username"
}

variable docker_login_server {
  type    = string
  default = "https://127.0.0.1:5000"
}

variable docker_login_password {
  type    = string
  default = "secret"
}

# ANSIBLE PLAYBOOK - PAYARA INSTALL
variable payara_version {
  type    = string
  default = "5.2020.7"
}

variable java_version {
  type    = string
  default = "openjdk-11-jre-headless"
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
