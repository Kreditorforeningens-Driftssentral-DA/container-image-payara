# PAYARA SERVER CONTAINER

![Private Image Builds](https://github.com/Kreditorforeningens-Driftssentral-DA/container-image-payara/workflows/Packer%20Private/badge.svg?branch=main)
![Public Image Builds](https://github.com/Kreditorforeningens-Driftssentral-DA/container-image-payara/workflows/Packer%20Public/badge.svg?branch=main)

Container image for Payara Server (java application server) using
Packer, Ansible, Shell (bash), Git, GitHub Actions

* Payara official [Dockerfile]("https://hub.docker.com/r/payara/server-full/Dockerfile") on Docker Hub.
* Payara [Releases]("https://github.com/payara/Payara/releases") on GitHub

## FEATURES

>   * Automated build of public container, with default values
>   * Easy to build/modify custom versions & push to e.g. private repository

## ONGOING

> * Cleanup/complete github action pipeline(s)
> * Publish public image build(s) on dockerhub via pipeline
> * Create/find acceptable ansible role for the Payara installation
