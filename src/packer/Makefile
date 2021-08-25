# Variables named PKR_VAR_* are passed to Packer build
export TARGET_BUILD	 ?= 5.2021.6-11
export TARGET_SOURCE ?= docker.UBUNTU_BASE_2004

# Packer variables
export PKR_VAR_docker_image_name ?= local/payara
export PKR_VAR_build_date 			 ?= 2021.34

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

