build {
  name = "v5-2020-7_jre-11"

  sources = ["source.docker.UBUNTU_2004"]

  # PROVISION TIMEZONE & LOCALE
  provisioner "ansible" {
    user          = "root"
    playbook_file = "ansible/provision.yml"
    extra_arguments = [
      "--extra-vars",
      join(" ", [
        "TIMEZONE_CONTINENT=${var.timezone_continent}",
        "TIMEZONE_CITY=${var.timezone_city}",
        "LOCALE_NAME=${var.locale_name}",
        "LOCALE_LANGUAGE_PACKAGE=${var.locale_package}",
        "JAVA_VERSION=${var.java_version}",
        "JAVA_MAX_RAM=${var.java_max_ram}",
        "PAYARA_GROUP=${var.payara_group}",
        "PAYARA_USER=${var.payara_user}",
        "PAYARA_VERSION_MAJOR=${var.payara_version_major}",
        "PAYARA_VERSION_MINOR=${var.payara_version_minor}",
        "PAYARA_DOMAIN=${var.payara_domain}",
        "PAYARA_ASADMIN_PASSWORD=${var.payara_asadmin_password}",
      ])
    ]
  }

  # TAG CONTAINER & PUSH TO REGISTRY
  post-processors {
    post-processor "docker-tag" {
      only       = ["docker.UBUNTU_2004"]
      tags       = ["v5-2020-7_jre-11"]
      repository = var.docker_image_name
    }

    post-processor "docker-push" {
      name           = "push"
      login          = true
      login_username = var.docker_login_username
      login_server   = var.docker_login_server
      login_password = var.docker_login_password
    }
  }
}
