# FEATURES
 * HashiCorp Packer used for building
 * Easy to customize. Configuration is based on official Dockerfile
 * Base image is Ubuntu 20.04 (customized)
 * OpenJDK v11 (jre+headless)
 * Payara v5.2021.6
 * GitHub Actions pipelines
 * Uses tini & gosu. Run as root or unprivileged
 * Allows custom startup-scripts without rebuilding container
 * GitHub Actions pipelines

# CHANGELOG
## BUILD 5.2021.6-11
#### IMPROVEMENTS (2021-08-24)
> * Added logback as default logging driver

