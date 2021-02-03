# Variables named PKR_VAR_* are passed to Packer build
export TARGET_BUILD							 ?= v5-2020-7_jre-11.docker.UBUNTU_2004

export PKR_VAR_docker_image_name ?= local/payara
export PKR_VAR_docker_image_tags ?= ["11"]
export PKR_VAR_java_version      ?= "openjdk-11-jre-headless"
export PKR_VAR_payara_version    ?= "5.2020.7"
export PKR_VAR_asadmin_password  ?= "Secret123"

build:
	@packer build -only=${TARGET_BUILD} -except=push .
.PHONY: build

push:
	@packer build -only=${TARGET_BUILD} .
.PHONY: push

clean:
	@echo "TODO.."
.PHONY: clean
