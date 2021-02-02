# Variables passed to PACKER (PKR_VAR_)
export PKR_VAR_openjdk_version ?= "11"
export PKR_VAR_payara_version  ?= "5.2020.7"

export PKR_VAR_docker_image_name ?= local/payara
export PKR_VAR_docker_image_tags ?= ["dev"]
export PKR_VAR_docker_login_username ?= dist
export PKR_VAR_docker_login_password ?= kred.container.distrepos.com
export PKR_VAR_docker_login_server   ?= kred.container.distrepos.com

init:
	@echo "TEST: ${TEST}"
.PHONY: init

build:
	@packer build -except=push .
.PHONY: build

test:
	@docker run
.PHONY: test

push:
	@packer build -only=push .
.PHONY: push