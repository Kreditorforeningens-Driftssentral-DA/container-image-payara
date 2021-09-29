# =================================================================================================
# BUILD VARIABLES
# =================================================================================================

# -------------------------------------------------------------------------------------------------
# CONTAINER REGISTRY
# -------------------------------------------------------------------------------------------------

variable container_image_name {
  type    = string
  default = "local/payara"
}

variable container_image_tags {
  type    = list(string)
  default = []
}

variable container_registry_username {
  type    = string
  default = "username"
}

variable container_registry_server {
  type    = string
  default = "https://127.0.0.1:5000"
}

variable container_registry_password {
  type    = string
  default = "secret"
}

# -------------------------------------------------------------------------------------------------
# ANSIBLE PLAYBOOK VARIABLES
# -------------------------------------------------------------------------------------------------

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
  default = "2021.7"
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
