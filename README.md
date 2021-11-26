# PAYARA SERVER

[![Payara (Public)](https://github.com/Kreditorforeningens-Driftssentral-DA/container-image-payara/actions/workflows/docker-public.yml/badge.svg)](https://github.com/Kreditorforeningens-Driftssentral-DA/container-image-payara/actions/workflows/docker-public.yml)

These images are based on the official Payara Server Community Edition, running on Azul Zulu OpenJDK (Debian)

  * Sourcode on [GitHub](https://github.com/Kreditorforeningens-Driftssentral-DA/container-image-payara)
  * Image on [DockerHub](https://registry.hub.docker.com/r/kdsda/payara)
  * Official Payara [Releases](https://github.com/payara/Payara/releases)

#### Features
  * Uses gosu & dumb-init
  * Runs init-scripts as root, before starting the server as unprivileged (default) user.
  * secure-admin enabled
  * Improved JVM defaults: '-XX:MaxRAMPercentage=85.0 -XX:InitialRAMPercentage=85.0 -XX:+ExitOnOutOfMemoryError'
  * Automated monthly builds (ref. workflow)
  * Logback config-option added (req. file: ${CONFIG_DIR}/logback.xml)

```bash
# Public image admin-credentials
admin / Admin123
```

## TAG FORMAT
* \<JavaVersion\>.\<PayaraVersion\>-\<BuildTag\>
* sha-\<SHA\>

## EXAMPLE USE

```bash
# Starting server ..
docker run --rm -it -p 8080:8080 -p 4848:4848 -e TZ=Europe/Oslo -e LC_ALL=nb_NO.ISO-8859-1 kdsda/payara:11.5.2021.9-main
```

## Checking JAVA defaults
```bash
java -XX:+PrintFlagsFinal -version | grep -E "UseContainerSupport | InitialRAMPercentage | MaxRAMPercentage | MinRAMPercentage | MaxHeapSize"
```
