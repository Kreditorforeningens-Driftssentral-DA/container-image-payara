# =================================================================================================
# BUILD CUSTOMIZATION
# =================================================================================================
#https://www.packer.io/docs/templates/hcl_templates/contextual-variables

locals {
  timezone_continent = var.timezone_continent
  timezone_city      = var.timezone_city

  java_version = var.java_version
  java_max_ram = var.java_max_ram

  payara_version_major    = var.payara_version_major
  payara_version_minor    = var.payara_version_minor
  payara_user             = var.payara_user
  payara_home             = var.payara_home
  payara_domain           = var.payara_domain
  payara_asadmin_password = var.payara_asadmin_password

  container_registry_name     = var.container_registry_name
  container_extra_tags        = var.container_extra_tags
  container_registry_server   = var.container_registry_server
  container_registry_username = var.container_registry_username
  container_registry_password = var.container_registry_password
}

# =================================================================================================
# BUILD SOURCE(S)
# =================================================================================================

source docker "DEBIAN" {
  image       = "registry.hub.docker.com/library/debian:latest"
  export_path = "./payara-debian.tar"
}

source docker "UBUNTU" {
  image       = "registry.hub.docker.com/library/ubuntu:latest"
  export_path = "./payara-ubuntu.tar"
}

source docker "ALPINE" {
  image       = "registry.hub.docker.com/library/alpine:latest"
  export_path = "./payara-alpine.tar"
}

# =================================================================================================
# BUILD & PROVISION IMAGE(S)
# =================================================================================================

build {
  name = "payara"

  sources = [
    "source.docker.DEBIAN",
    "source.docker.UBUNTU",
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
      <<-PREPROVISIONING
      echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
      apt-get update
      apt-get -qqy install --no-install-recommends apt-utils > /dev/null 2>&1 
      apt-get -qqy install --no-install-recommends python3-simplejson python3-apt jq unzip tar curl gnupg2
      apt-get autoclean
      PREPROVISIONING
    ]
  }

  # -------------------------------------------------------------------------------------------------
  # PROVISION
  # -------------------------------------------------------------------------------------------------

  provisioner "ansible" {
    only = [
      "docker.DEBIAN",
      "docker.UBUNTU",
    ]

    user          = "root"
    playbook_file = "./context/ansible/provision.debian.yml"
    extra_arguments = [
      "--extra-vars",
      join(" ", [
        "\"",
        "TIMEZONE_CONTINENT=${local.timezone_continent}",
        "TIMEZONE_CITY=${local.timezone_city}",
        "JAVA_VERSION=${local.java_version}",
        "JAVA_MAX_RAM=${local.java_max_ram}",
        "PAYARA_USER=${local.payara_user}",
        "PAYARA_HOME=${local.payara_home}",
        "PAYARA_VERSION_MAJOR=${local.payara_version_major}",
        "PAYARA_VERSION_MINOR=${local.payara_version_minor}",
        "PAYARA_DOMAIN=${local.payara_domain}",
        "PAYARA_ASADMIN_PASSWORD=${local.payara_asadmin_password}",
        "\"",
      ])
    ]
  }

  # -------------------------------------------------------------------------------------------------
  # FINALIZE
  # -------------------------------------------------------------------------------------------------

  # TAG CONTAINER & PUSH TO REGISTRY
  post-processors {

    # Import to local registry
    post-processor "docker-import" {
      only = [
        "docker.DEBIAN",
        "docker.UBUNTU",
      ]

      repository = local.container_registry_name
      tag        = lower("payara-${build.ID}")

      changes = [
        "EXPOSE 4848 8080 8181 9009",
        "ENV TZ Europe/Oslo",
        "ENV LANG nb_NO.ISO-8859-1",
        "ENV LANGUAGE nb_NO.ISO-8859-1",
        "ENV JAVA_TOOL_OPTIONS \"-XX:MaxRAMPercentage=${local.java_max_ram}\"",
        "ENV PAYARA_USER ${local.payara_user}",
        "ENV PAYARA_DIR ${local.payara_home}",
        "ENV CONFIG_DIR $${PAYARA_DIR}/config",
        "ENV SCRIPT_DIR $${PAYARA_DIR}/scripts",
        "ENV DEPLOY_DIR $${PAYARA_DIR}/deploy",
        "ENV PATH_PREBOOT_COMMANDS $${PAYARA_DIR}/pre-boot-commands.asadmin",
        "ENV PATH_POSTBOOT_COMMANDS $${PAYARA_DIR}/post-boot-commands.asadmin",
        "ENV DOMAIN_NAME ${local.payara_domain}",
        "ENV ADMIN_USER admin",
        "ENV PATH_ADMIN_SECRET $${PAYARA_DIR}/secret.txt",
        "WORKDIR $${PAYARA_DIR}",
        "CMD [\"/usr/bin/tini\",\"--\",\"/docker-entrypoint.sh\"]",
      ]
    }

    # Add tags & name
    post-processor "docker-tag" {
      only = [
        "docker.DEBIAN",
      ]

      repository = local.container_registry_name
      tags = concat(local.container_extra_tags, [
        "debian",
        "debian-latest",
        "debian-${local.payara_version_major}.${local.payara_version_minor}",
        "debian-${uuidv5("oid", "${local.payara_version_major}.${local.payara_version_minor}")}",
        "debian-${formatdate("YYYY-MM-DD", timestamp())}",
      ])
    }

    post-processor "docker-tag" {
      only = [
        "docker.UBUNTU",
      ]

      repository = local.container_registry_name
      tags = concat(local.container_extra_tags, [
        "latest",
        "ubuntu",
        "${local.payara_version_major}.${local.payara_version_minor}",
        uuidv5("oid", "${local.payara_version_major}.${local.payara_version_minor}"),
        formatdate("YYYY-MM-DD", timestamp()),
      ])
    }

    # Push to external registry
    post-processor "docker-push" {
      only = [
        "docker.DEBIAN",
        "docker.UBUNTU",
      ]

      name  = "push"
      login = true

      login_server   = local.container_registry_server
      login_username = local.container_registry_username
      login_password = local.container_registry_password
    }
  }
}