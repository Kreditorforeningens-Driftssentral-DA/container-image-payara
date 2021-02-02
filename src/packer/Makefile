# Variables passed to PACKER
#export PKR_VAR_image_name      ?= local/payara
#export PKR_VAR_image_tags      ?= ["dev"]
#export PKR_VAR_openjdk_version ?= "11"
#export PKR_VAR_payara_version  ?= "5.2020.7"

init:
	@echo "Download assets"
.PHONY: init

build:
	@packer build .
.PHONY: build

test:
	@docker run
.PHONY: test