# CONTAINER SETTINGS
variable docker_image_name {
  type    = string
  default = "local/payara"
}

variable docker_image_tags {
  type    = list(string)
  default = ["dev"]
}

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

# ANSIBLE PLAYBOOK VARIABLES
variable timezone_continent {
  type    = string
  default = "Europe"
}

variable timezone_city {
  type    = string
  default = "Oslo"
}

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

variable java_version {
  type    = string
  default = "openjdk-11-jre-headless"
}

variable java_max_ram {
  type    = string
  default = "85"
}

variable payara_version_major {
  type    = string
  default = "5"
}

variable payara_version_minor {
  type    = string
  default = "2021.3"
}

variable payara_user {
  type    = string
  default = "payara"
}

variable payara_group {
  type    = string
  default = "payara"
}

variable payara_domain {
  type    = string
  default = "production"
}

variable payara_asadmin_password {
  type    = string
  default = "Admin123"
}
