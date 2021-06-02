# Variables named PKR_VAR_* are passed to Packer build
export TARGET_BUILD	 ?= 5.2021.3-11
export TARGET_SOURCE ?= docker.UBUNTU_BASE_2004

# Packer variables
export PKR_VAR_docker_image_name ?= local/payara

build:
	@packer build -only=${TARGET_BUILD}.${TARGET_SOURCE} -except=push .
.PHONY: build

push:
	@packer build -only=${TARGET_BUILD}.${TARGET_SOURCE} .
.PHONY: push

test:
	@docker run --rm -d \
		--name payara-test \
		-p 8080:8080 -p 4848:4848 -p 9009:9009 \
		${PKR_VAR_docker_image_name}:${TARGET_BUILD}
	@docker ps
.PHONY: test

clean:
	@rm -rf ansible/cache/*
.PHONY: clean

