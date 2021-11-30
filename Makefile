# =================================================================================================
# CUSTOMIZE
# =================================================================================================

FILTER        ?= '*.UBUNTU'
IMAGE         ?= local/payara
MAJOR         ?= 5
MINOR         ?= 2021.9
JAVA_PLATFORM ?= openjdk
JAVA_VERSION  ?= 11
JAVA_EDITION  ?= jre-headless

# =================================================================================================
# PACKER VARIABLES
# - PKR_VAR_* are passed to Packer build
# =================================================================================================

export PKR_VAR_java_platform			     := ${JAVA_PLATFORM}
export PKR_VAR_java_version				     := ${JAVA_VERSION}
export PKR_VAR_java_edition				     := ${JAVA_EDITION}
export PKR_VAR_payara_version_major    := ${MAJOR}
export PKR_VAR_payara_version_minor    := ${MINOR}
export PKR_VAR_container_registry_name := ${IMAGE}

export DOCKER_image 	:= azul/zulu-openjdk-debian:${JAVA_VERSION}
export DOCKER_version := ${MAJOR}.${MINOR}
export DOCKER_jre     := ${JAVA_VERSION}

# =================================================================================================
# PACKER GOALS
# =================================================================================================

.PHONY: validate build push clean

validate:
	@packer validate -only=${FILTER} ./packer

build:
	@packer build -only=${FILTER} -except=push ./packer

push:
	@packer build -only=${FILTER} ./packer

clean:
	@rm -rf context/ansible/cache/*

# =================================================================================================
# DOCKER GOALS
# =================================================================================================
.PHONY: docker
dpublic:
	@DOCKER_BUILDKIT=1 \
	docker build ./docker \
	-f ./docker/Dockerfile.public \
	-t ${IMAGE}-public:${MAJOR} \
	--compress \
	--build-arg BASE_IMAGE=${DOCKER_image} \
	--build-arg PAYARA_VERSION=${DOCKER_version} \
	--build-arg JRE_VERSION=${DOCKER_jre}
