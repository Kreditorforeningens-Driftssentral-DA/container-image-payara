# =================================================================================================
# CUSTOMIZE
# =================================================================================================

TARGET ?= '*.docker.UBUNTU'
MAJOR  ?= 5
MINOR  ?= 2021.7
JAVA   ?= openjdk-11-jre-headless
NAME   ?= local/payara
TAGS   ?= ["jre","dev","local"]

# =================================================================================================
# PACKER VARIABLES
# - PKR_VAR_* are passed to Packer build
# =================================================================================================

export PKR_VAR_payara_version_major := ${MAJOR}
export PKR_VAR_payara_version_minor := ${MINOR}
export PKR_VAR_java_version					:= ${JAVA}
export PKR_VAR_docker_image_name    := ${NAME}
export PKR_VAR_container_image_tags := ${TAGS}

# =================================================================================================
# PACKER GOALS
# =================================================================================================
.PHONY: validate build push clean

validate:
	@packer validate -only=${TARGET} ./packer

build:
	@packer build -only=${TARGET} -except=push ./packer

push:
	@packer build -only=${TARGET} ./packer

clean:
	@rm -rf context/ansible/cache/*


