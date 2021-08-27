export IMAGE_TAG   := mvn:dev
export PROJECT_NAME := hello

.PHONY: build init example

build:
	@docker build -t ${IMAGE_TAG} .

init:
	@docker run -e PROJ_NAME=${PROJECT_NAME} -v `pwd`/projects:/exports --rm -it ${IMAGE_TAG} init

example:
	@docker run --rm -it -p 8080:8080 -v `pwd`/projects/example:/project maven:3-openjdk-11-slim /bin/bash