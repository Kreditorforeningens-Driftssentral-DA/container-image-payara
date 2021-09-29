# =================================================================================================
# BUILD CUSTOMIZATION
# =================================================================================================

locals {
  ansible_playbook_ubuntu = "./context/ansible/provision.ubuntu.yml"

  container_image_name = var.container_image_name
  container_image_tags = var.container_image_tags

  language = var.locale_env
  locale_name = var.locale_name
  locale_package = var.locale_package
  
  timezone_continent = var.timezone_continent
  timezone_city = var.timezone_city

  java_version = var.java_version
  java_max_ram = var.java_max_ram
  
  payara_group = var.payara_group
  payara_user = var.payara_user
  
  payara_version_major = var.payara_version_major
  payara_version_minor = var.payara_version_minor
  
  payara_domain = var.payara_domain
  payara_asadmin_password = var.payara_asadmin_password

  container_registry_server = var.container_registry_server
  container_registry_username = var.container_registry_username
  container_registry_password = var.container_registry_password
}

# =================================================================================================
# BUILD SOURCE(S)
# =================================================================================================

source docker "UBUNTU" {
  image  = "registry.hub.docker.com/library/ubuntu:focal"
  commit = true
  changes = [
    "EXPOSE 8080 4848 9009 8181",
    #"ENV JAVA_TOOL_OPTIONS=",
    #"ENV JVM_ARGS=",
    "ENV LANG=${var.locale_env}",
    "ENV LANGUAGE=${var.locale_env}",
    "ENV DOMAIN_NAME=${var.payara_domain}",
    "ENV PAYARA_USER=${var.payara_user}",
    "ENV PAYARA_DIR=/opt/payara",
    "ENV PAYARA_ARGS=",
    "ENV CONFIG_DIR=$${PAYARA_DIR}/config",
    "ENV SCRIPT_DIR=$${PAYARA_DIR}/scripts",
    "ENV DEPLOY_DIR=$${PAYARA_DIR}/deploy",
    "ENV DEPLOY_PROPS=",
    "ENV PATH_PREBOOT_COMMANDS=$${PAYARA_DIR}/pre-boot-commands.asadmin",
    "ENV PATH_POSTBOOT_COMMANDS=$${PAYARA_DIR}/post-boot-commands.asadmin",
    "ENV ADMIN_USER=admin",
    "ENV PATH_ADMIN_SECRET=$${PAYARA_DIR}/secret.txt",
    "WORKDIR $${PAYARA_DIR}",
    "ENTRYPOINT [\"/usr/bin/tini\",\"--\", \"/docker-entrypoint.sh\"]",
    "CMD [\"start\"]",
  ]
}

source docker "DEBIAN" {
  image  = "registry.hub.docker.com/library/debian:bullseye-slim"
  commit = true
  changes = [
    "EXPOSE 8080 4848 9009 8181",
    #"ENV JAVA_TOOL_OPTIONS=",
    #"ENV JVM_ARGS=",
    "ENV LANG=${var.locale_env}",
    "ENV LANGUAGE=${var.locale_env}",
    "ENV DOMAIN_NAME=${var.payara_domain}",
    "ENV PAYARA_USER=${var.payara_user}",
    "ENV PAYARA_DIR=/opt/payara",
    "ENV PAYARA_ARGS=",
    "ENV CONFIG_DIR=$${PAYARA_DIR}/config",
    "ENV SCRIPT_DIR=$${PAYARA_DIR}/scripts",
    "ENV DEPLOY_DIR=$${PAYARA_DIR}/deploy",
    "ENV DEPLOY_PROPS=",
    "ENV PATH_PREBOOT_COMMANDS=$${PAYARA_DIR}/pre-boot-commands.asadmin",
    "ENV PATH_POSTBOOT_COMMANDS=$${PAYARA_DIR}/post-boot-commands.asadmin",
    "ENV ADMIN_USER=admin",
    "ENV PATH_ADMIN_SECRET=$${PAYARA_DIR}/secret.txt",
    "WORKDIR $${PAYARA_DIR}",
    "ENTRYPOINT [\"/usr/bin/tini\",\"--\", \"/docker-entrypoint.sh\"]",
    "CMD [\"start\"]",
  ]
}

# =================================================================================================
# BUILD & PROVISION IMAGE(S)
# =================================================================================================

build {
  name = "5.2021.7"
  
  sources = [
    "source.docker.UBUNTU",
    "source.docker.DEBIAN",
  ]

# -------------------------------------------------------------------------------------------------
# PRE-PROVISION
# -------------------------------------------------------------------------------------------------
  
  # APT-distributions (Debian)
  provisioner "shell" {
    only = [
      "docker.DEBIAN",
      "docker.UBUNTU",
    ]

    inline = [
      <<-PREPROVISION
      echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
      apt-get update
      apt-get -qqy install --no-install-recommends apt-utils > /dev/null 2>&1 
      apt-get -qqy install --no-install-recommends python3-simplejson jq unzip curl gnupg2 tini gosu
      apt-get autoclean
      PREPROVISION
    ]
  }

# -------------------------------------------------------------------------------------------------
# PROVISION (ANSIBLE @HOST)
# -------------------------------------------------------------------------------------------------

  provisioner "ansible" {
    only = [
      "docker.UBUNTU",
    ]

    user = "root"
    playbook_file = local.ansible_playbook_ubuntu
    extra_arguments = [
      "--extra-vars",
      join(" ", [
        "TIMEZONE_CONTINENT=${local.timezone_continent}",
        "TIMEZONE_CITY=${local.timezone_city}",
        "LOCALE_NAME=${local.locale_name}",
        "LOCALE_LANGUAGE_PACKAGE=${local.locale_package}",
        "JAVA_VERSION=${local.java_version}",
        "JAVA_MAX_RAM=${local.java_max_ram}",
        "PAYARA_GROUP=${local.payara_group}",
        "PAYARA_USER=${local.payara_user}",
        "PAYARA_VERSION_MAJOR=${local.payara_version_major}",
        "PAYARA_VERSION_MINOR=${local.payara_version_minor}",
        "PAYARA_DOMAIN=${local.payara_domain}",
        "PAYARA_ASADMIN_PASSWORD=${local.payara_asadmin_password}",
      ])
    ]
  }

# -------------------------------------------------------------------------------------------------
# FINALIZE (TAG & PUSH)
# -------------------------------------------------------------------------------------------------

  # TAG CONTAINER & PUSH TO REGISTRY
  post-processors {
    post-processor "docker-tag" {
      only = [
        "docker.UBUNTU",
        "docker.DEBIAN",
      ]

      tags = concat(local.container_image_tags,["5.2021.7"])
      repository = local.container_image_name
    }

    post-processor "docker-push" {
      name = "push"
      login = true
      login_server = local.container_registry_server
      login_username = local.container_registry_username
      login_password = local.container_registry_password
    }
  }
}
