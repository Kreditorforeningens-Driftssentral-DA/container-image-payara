# Variables passed to PACKER (PKR_VAR_)
export PKR_VAR_docker_image_name ?= local/payara
export PKR_VAR_docker_image_tags ?= ["11"]
export PKR_VAR_java_version      ?= "openjdk-8-jre-headless"
export PKR_VAR_payara_version    ?= "5.2020.7"
export PKR_VAR_asadmin_password  ?= "Secret123"

#export PKR_VAR_docker_login_username ?= dist
#export PKR_VAR_docker_login_password ?= kred.container.distrepos.com
#export PKR_VAR_docker_login_server   ?= kred.container.distrepos.com

init:
	@echo "TEST: ${TEST}"
.PHONY: init

build:
	@packer build -only=v5-2020-7_jre-11.docker.UBUNTU_2004 -except=push .
.PHONY: build

push:
	@packer build -only=push-private .
.PHONY: push