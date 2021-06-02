# PAYARA SERVER CONTAINER

![Private Image Builds](https://github.com/Kreditorforeningens-Driftssentral-DA/container-image-payara/workflows/Packer%20Private/badge.svg?branch=main)
![Public Image Builds](https://github.com/Kreditorforeningens-Driftssentral-DA/container-image-payara/workflows/Packer%20Public/badge.svg?branch=main)

Container image for Payara Server (java application server) using
Packer, Ansible, Shell (bash), Git, GitHub Actions

```bash
# Public image admin-credentials
admin / Admin123
```

#### LINKS
* Public image on Docker Hub: https://registry.hub.docker.com/r/kdsda/payara, built from this repo
* Official [Payara Dockerfile](https://hub.docker.com/r/payara/server-full/Dockerfile) on Docker Hub.
* Official [Payara Releases](https://github.com/payara/Payara/releases) on GitHub

#### EXAMPLE

```bash
# Starting server ..
# Default secure-admin credentials (public image):
# admin / Admin123
docker run --rm -it -p 8080:8080 -p 4848:4848 <image>

# Access container via commandline
docker run --rm -it -p 8080:8080 -p 4848:4848 <image> debug
```

## FEATURES

> * Automated build of public container, with default values
> * Easy to build/modify custom versions & push to e.g. private repository

## ONGOING

> * Cleanup/complete github action pipeline(s)
> * Publish public image build(s) on dockerhub via pipeline
> * Create/find acceptable ansible role for the Payara installation
