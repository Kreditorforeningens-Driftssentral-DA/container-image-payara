build {
  name = "v5-2020-7_jre-11"

  sources = ["source.docker.UBUNTU_2004"]

  # ADD ENTRYPOINT SCRIPT
  provisioner "file" {
    sources     = ["docker-entrypoint.sh"]
    destination = "/"
  }

  provisioner "shell" {
    environment_vars = ["DEBIAN_FRONTEND=noninteractive"]
    inline = [
      "set -e",
      "chmod +x /docker-entrypoint.sh",
    ]
  }

  # PROVISION TIMEZONE & LOCALE
  provisioner "ansible" {
    user          = "root"
    playbook_file = "ansible/os-config.yml"
    extra_arguments = [
      "--extra-vars",
      join(" ", [
        "locale_name=${var.locale_name}",
        "locale_package=${var.locale_package}",
        "timezone_continent=${var.timezone_continent}",
        "timezone_city=${var.timezone_city}",
      ])
    ]
  }

  # INSTALL PAYARA & JAVA
  provisioner "ansible" {
    user          = "root"
    playbook_file = "ansible/payara-install.yml"
    extra_arguments = [
      "--extra-vars",
      join(" ", [
        "java_version=${var.java_version}",
        "payara_version=${var.payara_version}"
      ])
    ]
  }

  # CONFIGURE PAYARA
  provisioner "ansible" {
    user          = "root"
    playbook_file = "ansible/payara-config.yml"
    extra_arguments = [
      "--extra-vars",
      join(" ", [
        "asadmin_password=${var.asadmin_password}",
        "domain_name=${var.domain_name}",
      ])
    ]
  }

  # TAG CONTAINER & PUSH TO REGISTRY
  post-processors {
    post-processor "docker-tag" {
      only       = ["docker.UBUNTU_2004"]
      repository = var.docker_image_name
      tags       = ["v5-2020-7_jre-11"]
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
