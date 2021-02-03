source docker "UBUNTU_2004" {
  #image  = "registry.hub.docker.com/library/ubuntu:latest"
  image  = "registry.hub.docker.com/kdsda/ubuntu-base:2004"
  commit = true
  changes = [
    "EXPOSE 8080 4848 9009 8181",
    #"ENV JAVA_TOOL_OPTIONS=",
    #"ENV JVM_ARGS=",
    "ENV LANG=${var.locale_env}",
    "ENV LANGUAGE=${var.locale_env}",
    "ENV PAYARA_USER=payara",
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
  ]
}
