source "docker" "ubuntu" {
  image  = "registry.hub.docker.com/library/ubuntu:latest"
  commit = true
  changes = [
    "EXPOSE 8080 4848 9009 8181",
    "ENV LANG=${var.locale_env}",
    "ENV LANGUAGE=${var.locale_env}",
    "ENV JAVA_TOOL_OPTIONS=",
    "ENV JVM_ARGS=",
    "ENV PAYARA_DIR=/opt/payara",
    "ENV PAYARA_ARGS=",
    "ENV CONFIG_DIR=$${PAYARA_DIR}/config",
    "ENV SCRIPT_DIR=$${PAYARA_DIR}/scripts",
    "ENV DEPLOY_DIR=$${PAYARA_DIR}/deploy",
    "ENV DEPLOY_PROPS=",
    "ENV DOMAIN_NAME=${var.domain_name}",
    "ENV PATH_PREBOOT_COMMANDS=$${PAYARA_DIR}/pre-boot-commands.asadmin",
    "ENV PATH_POSTBOOT_COMMANDS=$${PAYARA_DIR}/post-boot-commands.asadmin",
    "ENV ADMIN_USER=admin",
    "ENV PATH_ADMIN_SECRET=$${PAYARA_DIR}/secret.txt",
    "WORKDIR $${PAYARA_DIR}",
    "ENTRYPOINT [\"/usr/bin/tini\", \"--\", \"/docker-entrypoint.sh\"]",
    #"CMD [\"/docker-entrypoint.sh\"]",
  ]
}

build {
  sources = [
    "source.docker.ubuntu"
  ]

  # Add entrypoint-script
  provisioner "file" {
    source      = "files/docker-entrypoint.sh"
    destination = "/docker-entrypoint.sh"
  }
  
  # Prepare base image
  provisioner "shell" {
    environment_vars = ["DEBIAN_FRONTEND=noninteractive"]
    inline = [
      "chmod +x /docker-entrypoint.sh",
      "apt-get -qqy update",
      "apt-get -qqy install dialog apt-utils tini gosu python3-minimal python3-apt unzip curl jq gnupg2",
      "apt-get -qqy clean",
    ]
  }

  # Configure timezone & add locale
  provisioner "ansible" {
    user = "root"
    playbook_file = "files/ansible/configure_os.yml"
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

  # Install payara & openjdk
  provisioner "ansible" {
    user = "root"
    playbook_file = "files/ansible/install_payara.yml"
    extra_arguments = [
      "--extra-vars",
      join(" ", [
        "openjdk_version=${var.openjdk_version}",
        "payara_version=${var.payara_version}"
      ])
    ]
  }

  # Configure payara
  provisioner "ansible" {
    user            = "root"
    playbook_file   = "files/ansible/configure_payara.yml"
    extra_arguments = [
      "--extra-vars",
      join(" ", [
        "asadmin_password=${var.asadmin_password}",
        "domain_name=${var.domain_name}",
      ])
    ]
  }

  # Tag the container image
  post-processors {
    post-processor "docker-tag" {
      repository = var.image_name
      tags       = var.image_tags
    }
  }
}
