build {
  name = "5.2021.6-11"
  sources = ["source.docker.UBUNTU_BASE_2004"]

  # CONFIGURE
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
      only       = ["docker.UBUNTU_BASE_2004"]
      tags       = [var.build_date,"5.2021.6-11","latest"]
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
